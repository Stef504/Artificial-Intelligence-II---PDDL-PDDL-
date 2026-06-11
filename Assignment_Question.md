## Assignment D4-V2: Search and Rescue– Unknown Victim Location Scenario

A rescue robot operates in a damaged building where the victim’s location is unknown. The robot must explore the environment to locate the victim before performing rescue operations.
Exploration requires visiting rooms and performing inspection actions.

## Domain Characteristics 
1. Robot: single mobile robot
2. Environment: known topology, unknown victim location
3. Tasks: exploration, detection, rescue
4. Constraints: information acquisition

## Modelling Guidelines
1. Represent inspection explicitly as an action.
2. Avoid assuming knowledge of victim location.
3. Ensure that detection influences subsequent actions.

## Q1– Basic PDDL Model
You must:
1. Approximate exploration using explicit predicates.
2. Provide:– one instance with known location– one requiring exploration
3. Provide valid plans.

## Q2– PDDL+ Model
You must:
1. Introduce a process modelling victim health degradation.
2. Introduce an event representing discovery or failure conditions.
3. Show how exploration delays affect rescue success.

## Discussion
Discuss:
1. limitations of classical PDDL for partial observability
2. interaction between sensing and time

## Things to consider
1. BFWS --F while implementing simple problem (PDDL) no time, no PDDL+.
2. When we  include time, duration switch to OPTIC (it can handle PDDL+) or Temporal Fast Downward .
3. While using PDDL+ switch to ENHSP, pls be careful it dosent handle time, if the problem has time!!

## Your README should clearly explain:

Project Overview
1. What your project is about 
2. The main idea and objective 

Visual Illustration (Recommended)
1. Include an image or diagram to explain your project concept 

PDDL Model Explanation
- How your domain and problem are designed 
- The logic behind your modeling choices 

How to Run the Project
- Step-by-step instructions to execute your PDDL files 

Results & Outputs
- Example plans 
- Outputs (text, images, metrics, etc.)