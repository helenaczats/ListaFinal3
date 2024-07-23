*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem
Library    Collections
Resource    ../../../../resources/common.resource
Variables    ../../../../resources/variables.py
Suite Setup    Run Requirements    ${url}    ${userName}    ${password}
Suite Teardown    Delete User    ${url}    ${userName}    ${password}

*** Variables ***
${isbn}    9781449325862

*** Test Cases ***

Create Books
    ${headers}    Create Dictionary    Content-Type=${content_type}    
    ...    Authorization=Bearer ${bearer} 
    ${body}    Evaluate    json.loads(open("./fixtures/json/book.json").read())
    Set To Dictionary   ${body}    userId=${userId}

    ${response}    POST    ${url}/BookStore/v1/Books    json=${body}    
    ...    headers=${headers}
    
    ${response_body}    Set Variable    ${response.json}
    Log To Console    ${response_body}

    Status Should Be    201  
    
Get Book
    ${headers}    Create Dictionary    Content-Type=${content_type}    
    ${response}    GET    url=${url}/BookStore/v1/Book?ISBN=${isbn}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[isbn]    9781449325862
    Should Be Equal    ${response_body}[title]    Git Pocket Guide
    Should Be Equal    ${response_body}[subTitle]    A Working Introduction
    Should Be Equal    ${response_body}[author]    Richard E. Silverman
    Should Be Equal    ${response_body}[publisher]    O'Reilly Media
    Should Be Equal    ${response_body}[pages]    ${{int(234)}}
    Should Be Equal    ${response_body}[description]    This pocket guide is the perfect on-the-job companion to Git, the distributed version control system. It provides a compact, readable introduction to Git for new users, as well as a reference to common commands and procedures for those of you with Git exp
    Should Be Equal    ${response_body}[website]    http://chimera.labs.oreilly.com/books/1230000000561/index.html