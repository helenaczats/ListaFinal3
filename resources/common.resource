*** Settings ***
Library    RequestsLibrary
Variables    ../../../../resources/variables.py

*** Keywords ***
Create User   
    [Arguments]    ${url}    ${userName}    ${password}
    ${headers}    Create Dictionary    Content-Type=${content_type}    
    ${body}    Create Dictionary    userName=${userName}    password=${password}  

    ${response}    POST    url=${url}/Account/v1/User    json=${body}    
     ...    headers=${headers}

    Status Should Be    201    
    ${userId}    Set Variable    ${response.json()}[userID]
    Set Suite Variable    ${userId}                          
    Log to Console    ${userId}

Create Bearer
    [Arguments]    ${url}    ${userName}    ${password}   

    ${body}    Create Dictionary    userName=${userName}    password=${password}
    ${response}    POST    url=${url}/Account/v1/GenerateToken    json=${body}

    Status Should Be    200
    ${bearer}    Set Variable    ${response.json()}[token]
    Set Suite Variable    ${bearer} 
    Log To Console    ${bearer}      

Create Authorized
    [Arguments]    ${url}    ${userName}    ${password}

    ${body}    Create Dictionary    userName=${userName}    password=${password}
    ${response}    POST    url=${url}/Account/v1/Authorized    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}    ${{bool(True)}}

Delete User   
    [Arguments]    ${url}    ${userName}    ${password}
    ${headers}    Create Dictionary    Content-Type=${content_type}  
    ...    Authorization=Bearer ${bearer}  
    ${body}    Create Dictionary    userId=${userId}

    ${response}    DELETE    url=${url}/Account/v1/User/${userId}    json=${body}    
     ...    headers=${headers}
    
    Status Should Be    204
    Log To Console    ${response}

Run Requirements
    [Arguments]    ${url}    ${userName}    ${password}
    Create User    ${url}    ${userName}    ${password}
    Create Bearer    ${url}   ${userName}    ${password}
    Create Authorized    ${url}    ${userName}    ${password}