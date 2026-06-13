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
    - Adding a function to monitor battery life , can not  be done. Durative actions for every action does not produce a plan and mutiple attempts have been made to fix it and it still does not work. 

With this information further assumptions have to be made about the world, such that the problem should now be able to distinguish between a dead or alive person. And there has to be a level of hierarchy to better understand the system. For example: Enter room -> listen for noise (human dB ranges from), turn in direction of noise, thermal scan if red+ plus then good sign, test chemical levels (which increase per m closer to victim), if levels indicate alive victim great move towars it, take photos and let the system decide the type of victim and how badly trapped they are, to rescue either pin location or if lost signal retrace steps to get back signal which will call out to SAR teams on which path it took and where it found the victim


Limitations of PDDL- we dont see the logic of when there is no sound source to turn it. In scenerios where its quite. Another limit is that the planner cant see the distance between the robot and the victim, also that we dont see the logic about remote connection and possible remote control of the robot (as this assumes autonomous), also 


What could be a function/ durative action (PDDL):
- The battery life of the robot will decrease will moving

What could be a process/ event (PDDL+):




(:action send-distress-signal
    :parameters (?loc - location ?signal - signal-level)
    :precondition (and
        (victim-vitals)
        (remap)
        (robot-at ?loc)
        (signal-connection ?loc ?signal)
        (= ?signal strong)
    )
    :effect (and
        (all-data-sent)
    )
)

(:durative-action move-to-signal
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and
        (at start (robot-at ?from))
        (at start (connected ?from ?to))
        (at start (remap))
        (over all (>= (battery-level) 10))


    )
)

(:action move 
    :parameters (?from ?to - location )
    :precondition (and 
        (robot-at ?from)
        (connected ?from ?to)
        (cleared-room ?from)
        
    )
    :effect(and 
        (not (robot-at ?from))
        (robot-at ?to)
         
    )
)

(:durative-action move 
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and 
        (at start (robot-at ?from))
        (at start (connected ?from ?to))
        (at start (not (remap)))
        (over all (>= (battery-level) 10))
        (at start (cleared-room ?from))  
        
    )
    :effect(and 
        (at start (not (robot-at ?from)))
        (at end (robot-at ?to))
        (at end (decrease (battery-level) 10))
         
    )
)


:fluents :durative-actions

    (= (battery-level) 100)