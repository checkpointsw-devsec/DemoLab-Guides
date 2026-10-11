Getting familiar with the environment 

From the Management Client you have SSH access to the gateways via the putty client on the desktop.	 
NOTE: If the instructor has not already asked you to do so reboot the management server by issuing the command “reboot” in clish via SSH. 

Opening SmartConsole from the desktop of Management Client, you can see that you have a fully deployed environment with a working security policy and working VPN configuration. 

a. As you see the environment consists of GW1 where windows client will use this getaway to access internet, and by default it can even use the second internet connection. 

<img width="967" height="320" alt="image" src="https://github.com/user-attachments/assets/f3c5d323-27b0-4870-bebb-973ffa4a06ee" />


b. The Client will use VPN to connect over internet to GW3 to reach the web server 

<img width="933" height="460" alt="image" src="https://github.com/user-attachments/assets/2e749103-55fa-4216-9716-2b3033186bfc" />


In SmartConsole you should see that SIC is established and communication is working to GW1. GW2 and GW3.  
**NOTE: GW2 is just acting as a router in this environment**

Review the configuration of GW1 and GW3,  

You should see that access control and Threat prevention is configured. 

Review the VPN domain defined for the gateways 

For GW1 you should se net_10.160.10.0  

For GW1 you should se net_10.160.40.0  

NOTE: Best practices are to use a group object here 

Review the setting of Link Selection.  
NOTE: Since the gateways have multiple external interfaces, it has been configured to use the primary internet connection interfaces  

GW1 - eth3 (10.160.20.10) 

GW2 - eth2 (10.160.30.30) 

for establishing VPN. 

Review the gw1-policy-package to familiarize yourself with the rule base.  

In the VPN Rules section, you will see that the VPN-Star community is used sending traffic over VPN. 

Review the settings of this community and validate that the Center gateway is gw3 and the satellite gateway is gw1 

Verify that Nat is disabled within the community 

Verify that “IKEv2 Only” is used as encryption settings 

Verify that VPN routing from satellites is configured “To center and other satellites through center” 

Make sure the policy is corrected loaded on the gateways by installing the access control and Threat Prevention policy on gw1 and gw3 

 

 

After policy installation completed, go to the Windows Client, log in as Alice and use the Microsoft Edge browser to Test connectivity to internet and to connectivity over VPN to the web server 

 
A screenshot of a computer

AI-generated content may be incorrect. 
NOTE: if you do not see the quick launch bar with the link to the Web Server (Demo Sever) just click on the + top open a new tab and the quick launch bar will be visible. 

 

Open the logs views in SmartConsole and search for log entries with destination 10.160.40.100 to verify that we have traffic across the VPN. 

 

Verify that the threat prevention is configured correctly and activated by opening the console for Attacker using CloudShare web UI 

login using to Attacker machine by CloudShare UI 'Keyboard > Send Password' menu 

On Kali Linux UI use start menu and start "zaproxy" 

When asked, select “No, I do not want to persist this session at this moment in time” and press start 

If there is a “Manage add-ons” window appearing just close that. 

on ZAP UI execute 'Automated Scan' 

A green circle with a lightning bolt and red arrow

AI-generated content may be incorrect. 

 

Enter URL to the web server; http://10.160.40.100  

Execute 'use ajax spider' by pressing 'attack' button and see in the lower window the progress 

 

Check logs on SmartConsole for IPS logs  

TIP: you can filter them with the following query (dst:10.160.40.100 AND blade:IPS) 

 

 

Part-1 Getting started 

Activate an evaluation subscription for SD-WAN to get ingestion quota for SD-WAN logs 

Note: If you start the SD-WAN product evaluation without an active SD-WAN contract activated in an attached user center account for your Infinity Portal Tenant, the log sharing for SD-WAN logs is not allowed. As a result, logs will be capped, and you are at risk of critical data loss. 

On the Management Client open the Edge browser and go to Check Point Usercenter 

Log in as workshop@checkpointlab.uk with password “Cpwins!W0rkSh0p!” 

Go to “Try Our Products” > “Product Evaluation” 

As instructed in the License section of the SD-WAN admin Guide, follow these steps: 

In the section “1 of 2 - Select Evaluation Product:” 

On the right side, select the radio button OTHER EVALUTION OPTIONS. 

Click Select a product. 

Search for SD-WAN and select Quantum SD-WAN Evaluation. 

In the bottom right corner, click Select. 

In the bottom right corner, click Next. 

In the section 2 of 2 - Provide Evaluation Info: 

In the User Center Account field, select the account with your name.  
“sd-wan-ws-[your name]” 

A screenshot of a survey

AI-generated content may be incorrect. 

In the Purpose of Evaluation section, select the applicable option. 

Select I confirm and acknowledge that .... 

In the bottom right corner, click Get Evaluation. 

Wait for the page to show the configuration and the evaluation steps. 

Go to https://portal.checkpoint.com and login 

Note: A new tenant called “sd-wan-ws-[your name]” has been created for you by the instructor. This tenant will be deleted after the workshop. 

Select the “sd-wan-ws-[your name]” in the top of the dropdown list in the infinity portal. 

Verify that the user center account is connected to your Infinity portal account by going to services and contracts under Account settings 

A screen shot of a computer

AI-generated content may be incorrect. 

Click on Manage Accounts and click on Sync 

Refresh the browser window and you should see a SD-WAN evaluation contract in the table and can continue with the SD-WAN evaluation process. 

 

 

Prepare your Infinity portal tenant and gw1 and gw3 for SD-WAN 

In infinity portal start by going to service Quantum > Security Management & Smart-1 Cloud to connect your on-premisses security management server to the infinity portal 

Select “Connect an existing Self-hosted Management” and agree to the policy 

Copy the token. Go to Infinity Services in SmartConsole, click "Get Started", paste the token, leave the settings as default and click Connect 
NOTE: If you use “Send Text” function in CloudShare make sure to have English keyboard layout on the Management Client otherwise the token is going to be filled with incorrect characters and the connection will fail  

Enable Configuration Sharing, this option can be found under the three dots in the upper right corner 

A screenshot of a computer

AI-generated content may be incorrect. 

The first step is to prepare the security gateways to run the SD-WAN functionality, you do this by connecting to the gateways via the Gaia Web portal from you Microsoft Edge Browser on the Management Client.  

On GW1 go to Network Interfaces and select the interfaces used for external / WAN access which is eth3 and eth1. On these interfaces enable the SD-WAN functionality, do not forget to provide a description for the interface. 

eth3, Comment: Primary external WAN,  
enable use as SD-WAN interface, Next Hop address 10.160.20.1, Tag ISP1 

eth1, Comment: Secondary external WAN,  
enable use as SD-WAN interface, Next Hop address 10.160.21.1, Tag ISP2 

 

Do the same on GW3, use the following values for the parameters 

eth2, Comment: Primary external WAN,  
Enable use as SD-WAN interface, Next hop address 10.160.30.1, Tag ISP1 

eth1, Comment: Primary external WAN,  
enable use as SD-WAN interface, Next hop address 10.160.31.1, Tag ISP2 

 

Once the gateways are prepared go back to SmartConsole to check that the configuration sharing process has finished by clicking the three dots. We are now ready start configuring SD-WAN for the environment by going to the SD-WAN service in the infinity portal and clicking “Request Evaluation” 

Once the SD-WAN Service has loaded you can see that the management server is connected, and configuration sharing is working by clicking “DETAILS” 

NOTE: Log sharing is disabled and not necessary for SD-WAN, this can be activated at later stage when needed. 

You enable the connectivity layer between the gateways and the infinity portal by using the quantum profile that you can find under the Network view > Profiles in the SD-WAN page. 

Note: You can see that this Quantum Profile is associated with the on-premises management server. 

Open the profile and copy the deployment command “nano-egg --install --token ******” 

Go back to SmartConsole and open the Gateways & Servers view, select gw1 and run a one time script by pasting the deployment command into the script body window and click Run. 

Do the same for gw3 

When the command execution is completed go back to the SD-WAN service in the Infinity Portal and check that the gateways are connected via the agent. This can be seen under Network > Agents. As you see the SD-WAN functionality is not yet enabled 
 
 

 

Configure SD-WAN for GW1 and GW3 

To enable the SD-WAN functionality, go to the “getting started” section in the SD-WAN service in the Infinity Portal and open the wizard  

Leave “environment” settings and “use cases” settings as default 

Select gw1 and gw3 to be used 

For WAN link mapping use the tags you previously defined on the gateway 

A screenshot of a computer

AI-generated content may be incorrect. 

Completer the wizards, you can publish the changes later. 

As you see, you will now have a pre-defined SD-WAN steering policy. 

You also have pre-defined SD-WAN steering objects 

Click on the Web Conference steering object to review it. As you can see this object is used for local breakout functionality where all relevant WAN links are used and we have pre-defined values for jitter latency and packet loss and the order which the WAN links are selected.   

Click on the Default Overlay steering object to review it. As you can see it is defined as a VPN overlay object where all WAN links are used and for our VPN overlay functionality, the WAN utilization is here by default configured to aggregation mode to use all VPN tunnels that meet the threshold criteria. 

Close the steering object and go to “WAN link Mapping” to see the mapping of physical interfaces to the WAN link mappings 

Enforce the policy, this will ask you to publish the any changes 

Go to the Agents view, you will eventually see that the agents have downloaded the new policy and activated SD-WAN 

 

Go to the monitoring dashboard to observe more details, where you can see that you have two connected gateways  

 

Test your SD-WAN configuration 

Go back to the Windows Client and open the browser in incognito mode, test the connection to BBC over internet and the Web server  (Demo Server) over VPN. 

Open SmartConsole and go to the log view, search for destination logs to the web server (10.160.40.100) and review one of the latest encrypt log. 
Inhere you can see that the encrypt log is now including the information that traffic is matching a SD-WAN rule, which steering object has been used and whish IPSEC transport was used. 

NOTE: If you do not see this in the log entry, go back to the client and refresh the connection by clicking crl+F5 a couple of times in the incognito windows in the edge browser. You even might need to restart the browser. 

 

Search the logs for traffic to bbc to review the local breakout log.  
As you can see the log is generated by the URL filtering blade and of type session log, session logs are logical abstraction summarizing multiple connection logs. 

To see the SD-WAN information go to the Connections tab and open one of the connection logs that was generated by the firewall blade. 

 

 

 

 

Basic troubleshooting 

Go to the SD-WAN service in the infinity portal click on Monitoring. 
In there you can see that the Overlay Tunnels are down. 

A screenshot of a computer

AI-generated content may be incorrect. 

Open Putty and connect to gw1 and start cpview, in cpview go to Advanced and SDWAN 

In there you can see information about Local Breakout probing Results, Next Hop Probing Results and Overlay Probing Results. 
A screenshot of a computer

AI-generated content may be incorrect. 

Looking at Overlay Probing Results we can see that the probing method is ICMP, State is DOWN and we have a high number of Consecutive drops. 

A screen shot of a computer

AI-generated content may be incorrect. 

Go to logs view in SmartConsole and filter on service icmp-requets we can see that echo request packages are dropped between gw1 and gw3 indicating that we are missing a rule to allow VPN overlay probing between gw1 and gw3. 

A screenshot of a computer

AI-generated content may be incorrect. 

On SmartConsole, in the two policy packages for gw1 and gw2 create a VPN probing rule. 
Put the rule in its own Section just below the Management rules in top of the two policy packages 
The rule should look like this: 
A screenshot of a computer

AI-generated content may be incorrect. 
 
TIP: You can copy the entire section with rules to the other policy package by collapsing the section, right click on the section title and select copy, go to the other policy package and just right click and paste below the section title 
A screenshot of a computer

AI-generated content may be incorrect. 

Do not forget to install the policies to gw1 and gw3 

Once policy installation completed, click on the rule and check that you have echo-request encrypt and decrypt logs on gw1 and gw3 in the log tab of the rule. 

go to the SD-WAN service in the infinity portal click on monitoring. There should now be 8 tunnels that are up. 
Under Overlay Tunnels Monitoring pick GW1 from the dropdown list, you should now be able to see information like Latency, Jitter, Packet Loss and SLA for the different VPN tunnels. 
A screenshot of a computer

AI-generated content may be incorrect. 

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

AI-generated content may be incorrect. 

A screenshot of a computer

AI-generated content may be incorrect.Change the settings of eth1 by setting  
the SD-WAN Next Hop IP-address to be  
10.160.21.20 and change the tag to a tag  
indicate a private connectivity,  
in this case we call it MPLS 

 

 You also need to change the secondary default rout to point to 10.160.21.20 
A screenshot of a computer

AI-generated content may be incorrect. 

You need to perform the same configuration on gw2, set the SD-WAN Next Hop IP-address of eth1 to be 10.160.31.20 and the tag to be MPLS 

Change the secondary default route to be 10.160.31.20 

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
