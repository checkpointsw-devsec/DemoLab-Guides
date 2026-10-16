Lab exercise 2: Enabling the Software Blades and features

The Workforce AI Security feature on the firewall requires supporting features to be enabled. Since most attendees will be familiar with management of Check Point firewalls, the following instructions are less detailed and will contain fewer screenshots. This provides an opportunity for attendees to think about how to achieve the goal, rather than being led step by step.


The Workforce AI Security feature uses HTTPS Inspection to provide visibility into encrypted sessions, and Application Control to recognise the AI traffic. Content Awareness recognises and extracts the prompt and sends the prompt data to the AI Defense Plane.


1. In SmartConsole, Edit the branch-gw firewall object and enable the required software blades:

a. Application Control

b. URL Filtering

c. Content Awareness

d. Workforce AI Security

2. Enable HTTPS Inspection as follows:

a. The certificates required for HTTPS Inspection are already created and trusted by the test client. Enable HTTPS Inspection with these settings:

<img width="567" height="544" alt="image" src="https://github.com/user-attachments/assets/65a2285a-238f-4852-9f4a-0aa712596e56" />


c. Click OK on the smaller popup then OK the branch-gw properties panel.

d. Publish the changes and install the policy to activate the software blades.




Lab exercise 3: Setting Up the Policies

Now that the required framework is in place, we can proceed to setting up the Security Policy.

By the end of this exercise you should understand the required policy structure and be able to set a policy to prevent users from releasing confidential information such as corporate intellectual property or personally identifiable information to SaaS AI platforms.


1. Return to the HQ-Win10 VM

2. In SmartConsole goto policy package AI-Network-Firewall. Find rule 10 in the Outbound section and change the action from Accept to be a new Inline layer. Name the layer something descriptive and enable the checkboxes for Applications & URL Filtering and for Content Awareness.

<img width="301" height="251" alt="image" src="https://github.com/user-attachments/assets/0b2af980-1681-4c37-ad73-019572ee62a1" />


3. Publish and install the policy to make the Workforce AI objects available.

4. Adding the new rules to control use of AI:

a. Add a new rule above 10.1 to create our Workforce AI controls.

b. Copy the source and destination objects from rule 10 into the new rule 10.1.

5. In the Services & Applications column, choose Workforce AI Supported App.

6. In the Content column, add some data types. Choose from the Workforce AI Data Types list.

a. For the first test, chose Source Code - Python.

b. Once you have chosen the data types, set the direction to upload.

c. Leave the action set to drop and set the logging to Detailed or Extended. Accounting is not relevant for this test but leaving it on will do no harm.

7. Create another rule below this to allow other default services traffic to the Internet. Add the DNS service and the Web Browsing application objects to the Services & Applications column.

8. The inline policy for Workforce AI should look something like this:

<img width="585" height="94" alt="image" src="https://github.com/user-attachments/assets/b132d0d4-09f4-437f-9c96-c99f89a7065b" />


9. Publish and install the policy.

Lab exercise 4: Testing the effectiveness of Workforce AI

Now that we understand the firewall requirements in terms of HTTPS Inspection, software blades and policy structure, we can proceed to testing Workforce AI security.

By the end of this exercise you should have proven that Workforce AI security in the firewall can prevent the leakage of personally identifiable information to SaaS AI platforms.


10. Return to the Branch-Win10 VM, ither via MobaXterm RDP on HQ-win10 or via the tab in the top.

1. Open an explorer window, navigate to the Documents folder and open the file “test prompt.txt”

a. In Notepad read the file and see that it contains python code, but does not have a complete python script. This code happens to check for the existence of a file path.

b. Select all text using CTRL+A, and then use the mouse right-click to copy the text.

2. Open Chrome and browse to gemini.google.com

a. Using the mouse right-click action, paste in the text that you copied.

b. Submit the prompt.

c. The prompt attempts to submit, and you should see the activity animation displayed below the prompt.

d. After a short while the screen will return to the starting state, with the prompt ready to submit.

3. Return to the HQ-Win10 machine and to SmartConsole.

a. Click on the Logs & Events tab. Filter the logs for blade:”Application Control” and find a Drop log:

<img width="561" height="170" alt="image" src="https://github.com/user-attachments/assets/e11d5b2a-2451-4d1e-921d-362e1c1232f5" />


c. Inspect one of the logs. There are several interesting details shown:


<img width="567" height="521" alt="image" src="https://github.com/user-attachments/assets/a6f4974f-0f1f-43d7-80f0-42834eba140f" />



Exercise 4 is now complete, and we have shown that the AI Network Firewall is able to block communications containing Corporate Intellectual Property.


Summary

The AI Network Firewall functionality of Check Point R82.20 has been configured and tested to show that by integration with Workforce AI, it is able to prevent leakage of confidential information to commonly-used AI services.


Reference Material

The R82.20 Security Management Administration Guide (Workforce AI section) is available here:

https://sc1.checkpoint.com/documents/R82.20/WebAdminGuides/EN/CP_R82.20_SecurityManagement_AdminGuide/Content/Topics-SECMG/GenAI.htm?tocpath=_____16


