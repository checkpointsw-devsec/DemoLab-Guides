**Getting familiar with the environment**

1. From the HQ-Win10 Client you have prepared SSH sessions to connect gateways with ssh.
  <p align="center">
<img width="285" height="253" alt="image" src="https://github.com/user-attachments/assets/8036e25a-d444-4449-a912-3adbee8df04a" />


Please Open SmartConsole from the HQ-Win10 desktop. 

<img width="890" height="204" alt="image" src="https://github.com/user-attachments/assets/b658e9ab-c4e1-424e-8961-2d8c5c0edc31" />

Please Check Gateways and make sure Gateways are shown with healty status.

Standard security policy package shows one cleanup polica that allows any communication.
A VPN Community is prepared configuration. 

a. As you see the environment consists of GW1 where windows client will use this getaway to access internet, and by default it can even use the second internet connection. 

<img width="967" height="320" alt="image" src="https://github.com/user-attachments/assets/f3c5d323-27b0-4870-bebb-973ffa4a06ee" />


b. The Client will use VPN to connect over internet to GW3 to reach the web server 

<img width="933" height="460" alt="image" src="https://github.com/user-attachments/assets/2e749103-55fa-4216-9716-2b3033186bfc" />


3. In SmartConsole you should see that SIC is established and communication is working to GW1. GW2 and GW3.  
**NOTE: GW2 is just acting as a router in this environment**

4. Review the configuration of GW1 and GW3,  

a. You should see that access control and Threat prevention is configured. 

b. Review the VPN domain defined for the gateways 

i. For GW1 you should se net_10.160.10.0  

ii. For GW1 you should se net_10.160.40.0  

***NOTE***: Best practices are to use a group object here 

c. Review the setting of Link Selection.  
NOTE: Since the gateways have multiple external interfaces, it has been configured to use the primary internet connection interfaces  

i. GW1 - eth3 (10.160.20.10) 

ii. GW2 - eth2 (10.160.30.30) 

for establishing VPN. 

5. Review the gw1-policy-package to familiarize yourself with the rule base.  

6. In the VPN Rules section, you will see that the VPN-Star community is used sending traffic over VPN. 

a. Review the settings of this community and validate that the Center gateway is gw3 and the satellite gateway is gw1 

b. Verify that Nat is disabled within the community 

c. Verify that “IKEv2 Only” is used as encryption settings 

d. Verify that VPN routing from satellites is configured “To center and other satellites through center” 

7. Make sure the policy is corrected loaded on the gateways by installing the access control and Threat Prevention policy on gw1 and gw3 

8. After policy installation completed, go to the Windows Client, log in as Alice and use the Microsoft Edge browser to Test connectivity to internet and to connectivity over VPN to the web server 

 <img width="870" height="257" alt="image" src="https://github.com/user-attachments/assets/84203c7c-3c86-41e5-9a1e-50c7cc826ea0" />


NOTE: if you do not see the quick launch bar with the link to the Web Server (Demo Sever) just click on the + top open a new tab and the quick launch bar will be visible. 

9. Open the logs views in SmartConsole and search for log entries with destination 10.160.40.100 to verify that we have traffic across the VPN. 

10. Verify that the threat prevention is configured correctly and activated by opening the console for Attacker using CloudShare web UI 

a. login using to Attacker machine by CloudShare UI 'Keyboard > Send Password' menu 

b. On Kali Linux UI use start menu and start "zaproxy" 

c. When asked, select “No, I do not want to persist this session at this moment in time” and press start 

d. If there is a “Manage add-ons” window appearing just close that. 

e. on ZAP UI execute 'Automated Scan' 

<img width="815" height="227" alt="image" src="https://github.com/user-attachments/assets/15ec57ef-9950-4eff-a10c-2e7b4a84517f" />

f. Enter URL to the web server; http://10.160.40.100  

g. Execute 'use ajax spider' by pressing 'attack' button and see in the lower window the progress 


11. Check logs on SmartConsole for IPS logs  

TIP: you can filter them with the following query (dst:10.160.40.100 AND blade:IPS) 

***Part-1 Getting started***

Activate an evaluation subscription for SD-WAN to get ingestion quota for SD-WAN logs 

Note: If you start the SD-WAN product evaluation without an active SD-WAN contract activated in an attached user center account for your Infinity Portal Tenant, the log sharing for SD-WAN logs is not allowed. As a result, logs will be capped, and you are at risk of critical data loss. 

1. On the Management Client open the Edge browser and go to Check Point Usercenter 

2. Log in as workshop@checkpointlab.uk with password “Cpwins!W0rkSh0p!” 

3. Go to “Try Our Products” > “Product Evaluation” 

4. As instructed in the License section of the SD-WAN admin Guide, follow these steps: 

a. In the section “1 of 2 - Select Evaluation Product:” 

b. On the right side, select the radio button OTHER EVALUTION OPTIONS. 

c. Click Select a product. 

d. Search for SD-WAN and select Quantum SD-WAN Evaluation. 

e. In the bottom right corner, click Select. 

f. In the bottom right corner, click Next. 

g. In the section 2 of 2 - Provide Evaluation Info: 

h. In the User Center Account field, select the account with your name.  
“sd-wan-ws-[your name]” 

<img width="467" height="205" alt="image" src="https://github.com/user-attachments/assets/319e5261-ef52-462b-8480-d2f1b5eaea12" />


i. In the Purpose of Evaluation section, select the applicable option. 

j. Select I confirm and acknowledge that .... 

k. In the bottom right corner, click Get Evaluation. 

l. Wait for the page to show the configuration and the evaluation steps. 

5. Go to https://portal.checkpoint.com and login 

Note: A new tenant called “sd-wan-ws-[your name]” has been created for you by the instructor. This tenant will be deleted after the workshop. 

6. Select the “sd-wan-ws-[your name]” in the top of the dropdown list in the infinity portal. 

7. Verify that the user center account is connected to your Infinity portal account by going to services and contracts under Account settings 

 <img width="189" height="96" alt="image" src="https://github.com/user-attachments/assets/d689b4fc-c538-4a1c-afa5-28be47f547b5" />


8. Click on Manage Accounts and click on Sync 

9. Refresh the browser window and you should see a SD-WAN evaluation contract in the table and can continue with the SD-WAN evaluation process. 

 <img width="1062" height="123" alt="image" src="https://github.com/user-attachments/assets/14f27593-b360-404e-b82b-93753e7986b9" />

***Prepare your Infinity portal tenant and gw1 and gw3 for SD-WAN***

1. In infinity portal start by going to service Quantum > Security Management & Smart-1 Cloud to connect your on-premisses security management server to the infinity portal 

2. Select “Connect an existing Self-hosted Management” and agree to the policy 

3. Copy the token. Go to Infinity Services in SmartConsole, click "Get Started", paste the token, leave the settings as default and click Connect 
NOTE: If you use “Send Text” function in CloudShare make sure to have English keyboard layout on the Management Client otherwise the token is going to be filled with incorrect characters and the connection will fail  

4. Enable Configuration Sharing, this option can be found under the three dots in the upper right corner 

<img width="524" height="272" alt="image" src="https://github.com/user-attachments/assets/1025b26a-dfe4-48ea-9c93-9aba613e5f71" />


5. The first step is to prepare the security gateways to run the SD-WAN functionality, you do this by connecting to the gateways via the Gaia Web portal from you Microsoft Edge Browser on the Management Client.  

<img width="337" height="439" alt="image" src="https://github.com/user-attachments/assets/e29a3bec-e2bd-4625-90fa-ed686d7280fc" />


6. On GW1 go to Network Interfaces and select the interfaces used for external / WAN access which is eth3 and eth1. On these interfaces enable the SD-WAN functionality, do not forget to provide a description for the interface. 

a. eth3, Comment: Primary external WAN,  
enable use as SD-WAN interface, Next Hop address 10.160.20.1, Tag ISP1 

b. eth1, Comment: Secondary external WAN,  
enable use as SD-WAN interface, Next Hop address 10.160.21.1, Tag ISP2 

7. Do the same on GW3, use the following values for the parameters 

a. eth2, Comment: Primary external WAN,  
Enable use as SD-WAN interface, Next hop address 10.160.30.1, Tag ISP1 

b. eth1, Comment: Primary external WAN,  
enable use as SD-WAN interface, Next hop address 10.160.31.1, Tag ISP2 

<img width="292" height="383" alt="image" src="https://github.com/user-attachments/assets/95ba9bb9-f06c-496c-9d6d-f6667b0b6dbf" />


8. Once the gateways are prepared go back to SmartConsole to check that the configuration sharing process has finished by clicking the three dots. We are now ready start configuring SD-WAN for the environment by going to the SD-WAN service in the infinity portal and clicking “Request Evaluation” 

9. Once the SD-WAN Service has loaded you can see that the management server is connected, and configuration sharing is working by clicking “DETAILS” 

NOTE: Log sharing is disabled and not necessary for SD-WAN, this can be activated at later stage when needed. 

10. You enable the connectivity layer between the gateways and the infinity portal by using the quantum profile that you can find under the Network view > Profiles in the SD-WAN page. 

Note: You can see that this Quantum Profile is associated with the on-premises management server. 

11. Open the profile and copy the deployment command “nano-egg --install --token ******” 

12. Go back to SmartConsole and open the Gateways & Servers view, select gw1 and run a one time script by pasting the deployment command into the script body window and click Run. 

13. Do the same for gw3 

14. When the command execution is completed go back to the SD-WAN service in the Infinity Portal and check that the gateways are connected via the agent. This can be seen under Network > Agents. As you see the SD-WAN functionality is not yet enabled 
 
<img width="337" height="439" alt="image" src="https://github.com/user-attachments/assets/de7a7029-0bfb-485e-a40e-7f59420b74c1" />

***Configure SD-WAN for GW1 and GW3***

To enable the SD-WAN functionality, go to the “getting started” section in the SD-WAN service in the Infinity Portal and open the wizard  

Leave “environment” settings and “use cases” settings as default 

Select gw1 and gw3 to be used 

For WAN link mapping use the tags you previously defined on the gateway 

<img width="1067" height="508" alt="image" src="https://github.com/user-attachments/assets/bc609ee0-2ef5-4862-a50a-dd0b40cc87b0" />
 

Completer the wizards, you can publish the changes later. 

As you see, you will now have a pre-defined SD-WAN steering policy. 

You also have pre-defined SD-WAN steering objects 

Click on the Web Conference steering object to review it. As you can see this object is used for local breakout functionality where all relevant WAN links are used and we have pre-defined values for jitter latency and packet loss and the order which the WAN links are selected.   

Click on the Default Overlay steering object to review it. As you can see it is defined as a VPN overlay object where all WAN links are used and for our VPN overlay functionality, the WAN utilization is here by default configured to aggregation mode to use all VPN tunnels that meet the threshold criteria. 

Close the steering object and go to “WAN link Mapping” to see the mapping of physical interfaces to the WAN link mappings 

Enforce the policy, this will ask you to publish the any changes 

Go to the Agents view, you will eventually see that the agents have downloaded the new policy and activated SD-WAN 

 <img width="1065" height="92" alt="image" src="https://github.com/user-attachments/assets/3d697dd7-19e8-4506-a04b-0fa167c6056e" />


Go to the monitoring dashboard to observe more details, where you can see that you have two connected gateways  

 

Test your SD-WAN configuration 

Go back to the Windows Client and open the browser in incognito mode, test the connection to BBC over internet and the Web server  (Demo Server) over VPN. 

Open SmartConsole and go to the log view, search for destination logs to the web server (10.160.40.100) and review one of the latest encrypt log. 
Inhere you can see that the encrypt log is now including the information that traffic is matching a SD-WAN rule, which steering object has been used and whish IPSEC transport was used. 

NOTE: If you do not see this in the log entry, go back to the client and refresh the connection by clicking crl+F5 a couple of times in the incognito windows in the edge browser. You even might need to restart the browser. 

 <img width="571" height="272" alt="image" src="https://github.com/user-attachments/assets/c54ce19f-1b73-4f25-a86a-fb96247044bc" />


Search the logs for traffic to bbc to review the local breakout log.  
As you can see the log is generated by the URL filtering blade and of type session log, session logs are logical abstraction summarizing multiple connection logs. 

To see the SD-WAN information go to the Connections tab and open one of the connection logs that was generated by the firewall blade. 

 <img width="1015" height="287" alt="image" src="https://github.com/user-attachments/assets/38346c91-fc39-4043-b90d-2ebdda15c358" />


 <img width="731" height="349" alt="image" src="https://github.com/user-attachments/assets/6b0d28ac-a211-4d4d-b84f-82943204ca2b" />


 

 

Basic troubleshooting 

Go to the SD-WAN service in the infinity portal click on Monitoring. 
In there you can see that the Overlay Tunnels are down. 

<img width="441" height="363" alt="image" src="https://github.com/user-attachments/assets/f6220726-46b8-4d44-9b30-3c057d7a318a" />


Open Putty and connect to gw1 and start cpview, in cpview go to Advanced and SDWAN 

In there you can see information about Local Breakout probing Results, Next Hop Probing Results and Overlay Probing Results. 

<img width="787" height="400" alt="image" src="https://github.com/user-attachments/assets/039c6ffe-2101-4dff-9f74-3da4dc51a003" />


Looking at Overlay Probing Results we can see that the probing method is ICMP, State is DOWN and we have a high number of Consecutive drops. 

<img width="1066" height="165" alt="image" src="https://github.com/user-attachments/assets/82b2a9b0-fd40-4778-974d-ad4f87a9bd3d" />

Go to logs view in SmartConsole and filter on service icmp-requets we can see that echo request packages are dropped between gw1 and gw3 indicating that we are missing a rule to allow VPN overlay probing between gw1 and gw3. 

<img width="1071" height="200" alt="image" src="https://github.com/user-attachments/assets/d3ce316d-f239-47af-9bf9-5952b0822485" />


On SmartConsole, in the two policy packages for gw1 and gw2 create a VPN probing rule. 
Put the rule in its own Section just below the Management rules in top of the two policy packages 
The rule should look like this: 

<img width="1067" height="162" alt="image" src="https://github.com/user-attachments/assets/6c3ce24a-abc6-437f-8e6a-e647f4a80022" />
 
 
TIP: You can copy the entire section with rules to the other policy package by collapsing the section, right click on the section title and select copy, go to the other policy package and just right click and paste below the section title 
<img width="826" height="320" alt="image" src="https://github.com/user-attachments/assets/8d9ed3c7-8445-4f35-a2ab-ff6c415ce9bf" />


Do not forget to install the policies to gw1 and gw3 

Once policy installation completed, click on the rule and check that you have echo-request encrypt and decrypt logs on gw1 and gw3 in the log tab of the rule. 

go to the SD-WAN service in the infinity portal click on monitoring. There should now be 8 tunnels that are up. 
Under Overlay Tunnels Monitoring pick GW1 from the dropdown list, you should now be able to see information like Latency, Jitter, Packet Loss and SLA for the different VPN tunnels. 
<img width="1070" height="191" alt="image" src="https://github.com/user-attachments/assets/d7eba17a-aad8-4d01-bed5-40313e2796ee" />


Open Putty and connect to gw1 and start cpview. In cpview go to Advanced and SDWAN 

In there you should be able to see similar information about Latency, Jitter, Packet Loss for the VPN tunnels 

Take a break and start with part 2 when you are instructed to do so by your trainer.
 

Part 2 - Configure a MPLS connection 

After taking a break and your trainer have instructed you to start, you are now ready to continue with Part 2, where we will change the configuration of the external WAN connections to private interfaces to simulate the usage of a MPLS connection. 

A diagram of a server

AI-generated content may be incorrect. 

 

Prepare your gateways to simulate a MPLS connection 

We will change the configuration of eth1 on gw1 and gw3 to use gw2 as a router simulating a MPLS connection. 

On the Management Client open Microsoft Edge and connect to the Gaia portal of gw1, as youi can see the Circuit ID of the SD-WAN interfaces are the same for both interfaces 


A screenshot of a computer

AI-generated content may be incorrect.Change the settings of eth1 by setting  
the SD-WAN Next Hop IP-address to be  
10.160.21.20 and change the tag to a tag  
indicate a private connectivity,  
in this case we call it MPLS 

  0000000000000000000000000000000000000000000000000000000000000

 You also need to change the secondary default rout to point to 10.160.21.20 

 <img width="719" height="134" alt="image" src="https://github.com/user-attachments/assets/74f77954-8052-48ed-aba9-2c77055bb5ce" />

<img width="328" height="388" alt="image" src="https://github.com/user-attachments/assets/f601c657-bbb9-4509-9ebb-b762336080a6" />

You need to perform the same configuration on gw2, set the SD-WAN Next Hop IP-address of eth1 to be 10.160.31.20 and the tag to be MPLS 

Change the secondary default route to be 10.160.31.20 
<img width="502" height="494" alt="image" src="https://github.com/user-attachments/assets/b301ca40-0e88-49b5-a368-1051d6197a29" />


Change the configuration of the WAN Link mapping 

We will change WAN Link mapping because we have a public interface that is now becoming a private interface to make the SD-WAN configuration aware of this. 

Go to the SD-WAN service in the infinity portal click on Network and WAN Link Mapping. To do this add the tag MPLS fort the private interface  
A screenshot of a computer

AI-generated content may be incorrect. 

Enforce the changes so that the change is communicated via the nano agent to the firewall worker executing the SD-WAN traffic steering on the gateway 

 

After the changes has been enforced you can see that the numbers of VPN tunnels have been reduced from 8 to 4.  

A screenshot of a computer

AI-generated content may be incorrect. 

 

Before we had 2 tunnels per interface per direction 2*4 = 8 now we have 1 tunnel per interface per direction 1*4 = 4.  

 

The reason for this is because we now have two circuit IDs one for each pair of interfaces instead of one, in SD-WAN, VPN tunnels will only be established between interfaces sharing the same circuit ID. 

 

In Cpview on the gateway you will see this reflected immediately. You will see that each gateway now have two VPN tunnels, one over the Public WAN connection and one over the private WAN connection. 

 

 

 

In “Overlay Tunnel Monitoring” in infinity portal you can after a while se the same information.  

 

 

In addition to the Gaia web portal and the clish show interface command, you can also see the two different circuit IDs for your interfaces by executing the command “sdwan_conf show eth1; sdwan_conf show eth3” in expert mode on gw1 

 

 

Go to the windows Client and verify that you have connectivity to the internet by accessing bbc.com and verify the VPN connectivity by accessing the Web Server (Demo Server) 

Go back to Management client and open Microsoft Edge, we will now use Web Smart Console to monitor the connectivity. 

In Microsoft Edge go to https://10.128.0.100/smartconsole/  

Open Logs & Events view and search for bbc and open the session log. 

Looking in the connection log of the session log you will see that SD-WAN is being used. 

 

If you search for the web server (10.160.40.100) you will find a encrypt connection log. In there you can see that SD-WAN is being used for this connection with the default overlay steering object and which interface was being used. 
 

Go to clish on GW1 and execute command “show configuration sdwan” find the interface tagged with ISP1 and shut it off with the command “set interface xxx state off” 

Refresh the web page to the demo server to generate a new log connection and log entry 

Go to SmartConsole and review the encryption for traffic to the Demo Server (10.160.40.100).  
You should now see that it uses the private MPLS conection and VPN peer 10.160.31.30 
A screenshot of a computer

AI-generated content may be incorrect. 

In “Overlay Tunnel Monitoring” in infinity portal you can for GW3 see that the tunnel over the public WAN link is down, this is also reflected in cpview 

NOTE: Using playblocks you can be automatically be notified or a ticket can automatically be created in for example Jira or ServiceNow when there is a link swap with ISP down event. You can find that automation by searching for SD-WAN in Automations under Playblooks. 
