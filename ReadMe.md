## Domain Characteristics 
1. Robot: single mobile robot
2. Environment: known topology, unknown victim location
3. Tasks: exploration, detection, rescue
4. Constraints: information acquisition


## Q1- Basic PDDL Model

1. Instance with known location
    1. Known location
      - Since the location of the victim is known, no explicit exploration is required for each room
      - Instead the robot simply navigates to the known room
      - And examines their health    
      - Rescue processes involve supplying oxygen since SAR teams would already have location of the victim 


2. Instance requiring exploration
    - Known topology means safe assumption of room connections
    - Four techqniues are used to identify the presence of a human:


    # Exploration: 
    - Since the location is not known the robot has to go into each room, perform the respective sensing actions (described below) before it can move onto the next room.
  
      1. Chemical Sensor:
           - Allows the robot to differentiate between living and deceased victims through a "fuzzy logic algorithm". This technology was implemented in a robot named SMURF. For living victims, a specific requirement had to be satisfied: a void concentration at least 10 times more than the ambient air background, indicating that the robot is situated in an enclosed environment where volatile organic compounds are more concentrated and isolated from external influences. Humans release volatile organic compounds (VOCs), which are present in faeces, urine, breath, skin, milk, blood, and saliva. Applying this criterion, the sensor can identify a living victim. 
           - In contrast, deceased individuals release distinct volatile organic compounds (VOCs), such as cadaverine, putrescine, skatole, and indole. 
           - The highest probability of successfully detecting either deceased or living victims was achieved when the fuzzy logic system was employed and the robot was positioned within 2-3 metres of the victim.

      2. Thermal Cameras:
          - Thermal imaging assists in detecting the presence of a living instance. The use of thermal cameras is to further analyse the scene and assist in verifying the victims' vital signs. This is done by the thermal camera technology itself; its provided data can assist SAR teams to better approach the situation. 
   
      3. Video Camera: 
          - The preliminary execution and discussion of that section are taken from "The study report primarily concentrated on the use of the method for unmanned aircraft systems (UASs)". This technique can also benefit search and rescue teams operating in collapsed structures.

         - The application of computer vision techniques alongside machine learning algorithms aids search-and-rescue (SAR) teams in analysing photographs to better locate victims in remote regions and discover missing individuals across extensive terrains. The algorithm was primarily trained with individuals of all ages and diverse clothing types, including camouflage, hiking attire, and casual wear. The algorithm aids SAR teams in concentrating their efforts on prospective target areas recognised by the system as having a high probability of containing victims. The ongoing advancement of this technology focuses on real-time regional identification to enhance search efficiency.

         - In the framework of this PDDL and SAR, including debris, this method can enhance the identification of an individual beneath rubble and facilitate autonomous detection. This algorithm must be trained across different categories, including dust-covered victims of diverse ages and in different attire, shirtless victims, and various bodily regions. This integration can further aid SAR teams in identifying their search victims and their current circumstances.  
      
      
      4. The use of two microphones:
         - A sound-based controller employing two microphones to orient the robot towards the source of the sound. 

         - This method differs from localisation since it emphasises balancing the noise between two microphones to ascertain the sound's direction. This balance of noise is achieved through the synchronisation of the time differences of arrival between the microphones. Due to the mathematical operations, any interference from echoes hardly impacts the robot's total heading direction.

         - In the context of PDDL and SAR teams for debris, this technology can enhance the robot's ability to autonomously orient itself towards any source of noise. Therefore, this technology can more effectively assist in locating the victim. 


    # Vital Signs
    - Once a victim has been located, and assuming the robot moves towards to victim (via ROS node setup). With the capabilities of the chemical sensor the system is able to detect whether the victim is alive or deceased. This assists SAR teams in focusing recourses in different areas. 
  
    # Rescue
    - Now that each of the rooms have been explored before moving onto the next room, the next step is rescue. Rescuing involves the robot sending the path followed to the SAR teams. This allows them to plan execution accordingly. 
    - If the robot every lost signal during execution it has the abilty to first locate the victim and then return to a state where signal was found as to send co-ordinates of where the victim is to SAR teams.

    # Challanges Faced:
    - correcting the logic to first explore each room prior to moving, fixed with the scan and cleared-room predicate
    - assesing victimes vitals , fixed with the use of the chemical sensor
    - scenario of signal lost and having to retrace steps so that all the information gathered can be sent , attempting to fix with disabling move from starting again and first having to check whether vitals were taken before moving to a better signal if a better signal is needed
    - Retraced steps because the addition of durative actions messed up the entire plan - 
    - Adding a function to monitor battery life , can not  be done via durative action. Durative actions for every action does not produce a plan and mutiple attempts have been made to fix it and it still does not work. Durative actions do not work in the study because of how dependent the actions are and this leads to a timeline collapse. 
    - Instead I still added battery life but as an instanuous decrease, which may not be an accurate representation as much it would of been durative action because for example during move it takes time its not  instanuous so it would of been better for the battery to drain over time of the action.
    - When using durative actions everything has to be a durative action or else it misuses and does a loophole

With this information further assumptions have to be made about the world, such that the problem should now be able to distinguish between a dead or alive person. And there has to be a level of hierarchy to better understand the system. For example: Enter room -> listen for noise (human dB ranges from), turn in direction of noise, thermal scan if red+ plus then good sign, test chemical levels (which increase per m closer to victim), if levels indicate alive victim great move towars it, take photos and let the system decide the type of victim and how badly trapped they are, to rescue either pin location or if lost signal retrace steps to get back signal which will call out to SAR teams on which path it took and where it found the victim


## Q2- PDDL+ Model 

3. Victim Health Degradtion
4. Discovery or failure conditions
5. Exploration delays affecting rescue success

- Logic stays fairly the same to Q2 but now i have to include events where Obstacle detetction overirdes everything and shuts down the search because the robot cant move
- Have to mointor the time taken to reach the victim which effects rescue the longer the time taken and the longer it takes to resolves problems (not something we can monitor in PDDL) the worse it is for rescue times because time is of the essence
- Victims health can be monitored via the sniffer sensor , other non conatct technology such as radar to check vitals has difficulties with the position of the body so maybe better to monitor the CO2 level, O2 levels, VOC levels and diduce the conditions of survival of the victim
- Success is when victim is found and data is sent
- Failure when the battery dies , victim not found, or battery dies before victim is found, false positive (which cant be modelled- limit of pddl), vital signs decrease and not enough time for SAR to reach person (i dont think it can be modelled because of limitation of pddl)


Worth noting:
when the battery is at 100 the planner failures because 
5 scans = 25
4 moves = 40 (at victim battery is left with 35)
Needs to find signal has to move back 2 rooms (-10) = 25 (-10)=15 below the battery life limit therefore fails and abort-mission is executed

So if you want to test whether the battery is causing the failure i increased it to 150

The reason for the `not(victim-vitals)` in the `process victim-health-background` is because once the robot reaches the victim it can rather get an accurate reading and then send the data and this cant be modelled in PDDL its mainly a hardware and software information. So what we check - based on conditions of the environment, the level of toxic cases in the enviornment how much the victims health will degrade over time. This should be mathemicatically calculated here is an estimate.
As a result 

(victim-vitals)
    (or (all-data-sent) (abort-mission))

Limitations with PDDL - it can not take disjunctive goals beacuse it will always try to find the quickest solution. The exmaple is that i tested what the planner will do when there is an obstacle in room2 for example... the goal given was   


```bash
(:goal(and
    (or (all-data-sent) (not(all-data-sent)))
    (or (victim-vitals) (abort-mission))
    
)

) 
```
The planner struggles or fails because it got given mutiple choices and it choose the easiest one. (i.e wait for the rescue time to run out and the same values can be true). 

This leads to making the goal abosulte and considering failure to produce a plan as a result of correct assumptions.

Lets reframe the goal to be that the robot has to have the (all-data-sent) this is only achieved when we actually get to mesure the victims vitals (therefore it has to reach the victim)

Scenerior 1:
Battery life = 100
victim-health = 100
rescue = 7200

- It successfully locates the victim, and reports back 

Scenario 2:
Battery Life = 80
victim-health = 100
rescue = 7200

- Plan fails to execute because the battery runs out before all-data-sent can be achieved

Scenario 3:
- An obsatcle is placed in the second room 
- Plan fails beacause it can not reach the victim to check its vital which activates the all-data-sent
- We expect failure


Scenario 4:
- Changing victims health 

Scenario 5:
- Deceased victims their health is st


# Challenges Faced
- When checking whether the victims health degrades over time using process it was noted that the time stays constant in the plan. 
- This is present because no durative actions were used. Durative actions weren't used because it caused a time collapse conflict. This conflict arised beacuse of how strict and dependent the actions are. 
- However, this is the time only for the action to take place while the real physics still degrades the rescue time and the victims health in the background so when the victims health starts at 40 it wont produce a plan because it abort the mission 
- The problem is that when i added the send-abort action, it gave a different output compared to the stacked output i was getting without. I used send-abort because i wanted the goal to either acheive all-data-sent with and without the victim vitals in cases where the battery died or the victims health was reached or the rescue time ran out  before the vital were taken. But because durative actions were not working I had no time indicates and so the planner chose the quickest path to complete the task so thats why i had graphs and depletions because it still acheived the saem results without proper execution.
- So we have to establish mutually exclusive technique 
- Durative actions are not supported via ENHSP therefore converting it where the actions start and end a process. Needed to ground processes gates and PDDL kinda stores values thats how it knows the ?to
- Processes having preconditions mess up the planner
- Having to use tokens (actions with certian predicates) to start and stop processes. 
- Very particular about which tokens are true/false. In order to execute an action or event once you have to make sure that the effect predicate is false before making it true. So for the events this was a crutial point
- g(n) = 60 seconds
- the choice to remove the (not(abort-mission)) from actions was because the planner would freeze and try to find a plan. This caused an infinite loop of searching for a plan. 
- keeping it in send-distress-signal means that the plan will fail when the victims health deplets after it has been found but if we remove it then we can note when the victims health deplets and still send a signal (which is what we want)

Limitations of PDDL- we dont see the logic of when there is no sound source to turn it. In scenerios where its quite. Another limit is that the planner cant see the distance between the robot and the victim, also that we dont see the logic about remote connection and possible remote control of the robot (as this assumes autonomous).
Another Limit is that it can not observe obstacles , also difficult to model false positives. It is still very abstract and only considers flag states like it has moved, not moved ect. and in cases of events. Also it is very particular (which isnt a limit just annoying). The planner couldnt handle durative actions when processes and events were introduced which leads to work around solutions. while some of the limits could be modelled it brings in complexity into the planner, which it does not handle very well unless the domain is very explicit and there are no ininfite loops. 
To legally output "No Plan Found," the AI is mathematically required to prove that every single timeline fails. It has to simulate the robot driving back and forth between Room 1 and Room 2. It has to simulate driving to Room 3, waiting 1 second, and driving back. It will simulate every single useless combination of driving and waiting until the battery hits 20 or the health hits 0 in every possible universe.
You can state that when using continuous time in ENHSP, failing states cause massive State-Space Explosions. Because the robot can "wait" for continuous fractions of a second, an unreachable goal forces the planner to evaluate thousands of useless waiting timelines, causing massive processing delays compared to a successful run.


file:///C:/Users/stefa/AppData/Local/Temp/plan-report--17152-f8loGlM5g1PE-.html
file:///C:/Users/stefa/AppData/Local/Temp/plan-report--17152-A5N0D6WaWNIp-.html
file:///C:/Users/stefa/AppData/Local/Temp/plan-report--17152-V0C6Dcg4A06S-.html
file:///C:/Users/stefa/AppData/Local/Temp/plan-report--17152-TGmmjW3eot92-.html