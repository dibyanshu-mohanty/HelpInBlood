# HelpInBlood

Your Pocket Friendly Go to Blood Bank. HelpInBlood conencts you to need in blood people and helps you to donate your blood for a good cause with all the 
safety checks and verification processes.

![HelpinBlood](https://user-images.githubusercontent.com/72657275/201524384-1df011cd-4b41-47d7-9a1a-64c365e8b493.png)



## Problem Statement

Blood banks today are very efﬁcient and almost well connected with all the hospitals in the city.  But the efﬁciency of the blood bank is only limited to well connected cities, and considering the population and topography of India, it’s practically impossible to build a physical blood bank everywhere. In emergency accidental cases mostly near highways, it’s very difﬁcult to arrange blood as there are only one or two hospitals around and the situation worsens in emergency accidental cases (when blood is not available with nearby blood banks) and rare medical cases when the blood group is rare, it’s very difﬁcult to arrange blood.


## Proposed Solution
- We are creating an interface for donors and the patients where live donors can be traced, and we have their locations on track.
- We are also creating a unified blood bank where blood banks can register and manage their inventories.
- Every time a patient marks a need request for blood, all the potential donors with the same blood group and across a speciﬁc radius will get a notiﬁcation for this   request. They can accept or reject the request and then the patient side will contact the accepted party.


## Tech Stack

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
<img src="https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black">

## Features Built till Now
- Realtime Location Tracking
- Seamless Request Transmission
- Enhanced Support System 

## Flow

```
| - Request Blood
  | - Choose Required Blood Type
    - Enter Phone Number
    | - Backend searches for Currently present donors within 20km and sends notifications
| - Donor Signin
  | - Enter basic details
    - Upload official ID and Complete Blood Test
  | - Manually the ideantification of the user is verified along with his health
    - Once verified, the user will start recieving notifications for requests
| - Search Requests
  | - Entered phone number is then searched in the backend for all the ongoing as well completed Blood requests and can be 
      easily tracked.
```

## Built By

[Dibyanshu Mohanty](https://github.com/dibyanshu-mohanty) - Full Stack Developer
