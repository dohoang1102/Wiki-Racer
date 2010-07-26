%matlabpool open local 4;


% WIKIPEDIA RACER
% DEVELOPED BY STEVEN LU AND ALEX KRASNER
% SUBMISSION DATE: SUN, MAY 04, 2010
% RUTGERS INTRO TO COMP. FOR ENG. SPRING 2010 PROJECT 4
% This program will try to find the shortest path between one wiki page to
% another wiki page. After 4 hops, and checking all the possible links, the
% program will not return an answer and give up.


%function [t2,t3]=wikiRace(pointer1,endPointer)

clear;clc; % clearing current screen and vars

% disclaimer messages and input prompts
fprintf('I am going to find the shortest possible path between two points.\n');
fprintf('We are deep linking to about 3 pages in, so about n^3 checks.\n');
fprintf('On average, that is ~150 links per page, so ~3,000,000 links.\n');
fprintf('This program may take over THREE hours, please be patient!\n');
fprintf('It may also not give you a result due to the complexity of Wikipedia, however\n');
fprintf('because we are checking so many, it most likely will give you a result; ~90 percent of the time\n');
fprintf('We try to reduce the number of links checked in each step, but this may cause a large memory footprint\n');
fprintf('The program may lag at points because it could be retrieving large pages or parse for a large amount of links\n');

pointer1 = input('\nplease input starting point: ', 's');
pointer1 = regexprep(pointer1, ' ', '_');
pointer1 = strcat('/wiki/',pointer1);
%pointer1 = '/wiki/Beyonce';
endPointer = input('please input ending point: ', 's');
endPointer = regexprep(endPointer, ' ', '_');
endPointer = strcat('/wiki/',endPointer);
%endPointer = '/wiki/First Amendment to the United States Constitution';

% SETTING UP ALL THE INITAL VARIABLES USED IN THIS PROGRAM.
pointer2 = '';
pointer3 = '';

alreadyChecked = {pointer1}; % the db/matrix to contain pages that have had "checkForMatch" run on it.

done = 0; %if this variable is set to true, the whole function breaks and displays the result

fprintf('\n\nPROGRAM IS NOW STARTING, PLEASE BE PATIENT.\n\n');
% FINDING LINKS FOR FIRST ORDER
link1=strcat('http://en.wikipedia.org',pointer1);
%page1=;

listOfLinks1 = parseForLinks(urlread(link1), ''); % grabbing all the links on our starting page.

if (~checkForMatch(listOfLinks1, endPointer)) % checking if our first page contains our endpoint.
    fprintf('\n\nCHECKED LINKS IN FIRST ORDER: %s\n\n', link1); % if not, we're gonna go deep into the links on our first page.
    for a = 1:length(listOfLinks1)
        if (done == 1) break; end % if it is done, we're gonna kill our loop
        
        pointer2 = listOfLinks1{1,a}; % setting our second pointer to what we are currently checking
        alreadyChecked = {alreadyChecked{1,:} pointer2};
        
        % SETTING UP LINK2 FOR READING 
        link2 = strcat('http://en.wikipedia.org',listOfLinks1{1,a}); 
        %disp(link2);
        %fprintf('%s\n',link2);
        
        % TRYING TO READ, SKIP IF RESULT IS BAD
        try
            page2 = urlread(link2);
        catch exception
            %disp('bad link');
            fprintf('bad link\n');
        end
        
        % PARASE FOR THE LINKS MAKING SURE WE SKIP THE ONES WE ALREADY DID
        % THEN UPDATE THE DATABASE FOR THE LINKS WE'RE PASSIN
        listOfLinks2 = parseForLinks(page2, alreadyChecked);
        
        if (~checkForMatch(listOfLinks2, endPointer))
            fprintf('\n\nCHECKED LINKS IN SECOND ORDER: %s\n\n', link2);
            fprintf('\n\nRUNNING LAST LAYER DEEP CHECKING ON: %s\n', link2);
            for b = 1:length(listOfLinks2);
                if (done == 1) break; end
                
                pointer3 = listOfLinks2{1,b};
                alreadyChecked = {alreadyChecked{1,:} pointer3}; %% updating the db to what we've deep checked
                
                link3 = strcat('http://en.wikipedia.org',listOfLinks2{1,b});
                %disp(link3);
                fprintf('%s\n',link3);
                try
                    page3 = urlread(link3);
                catch exception
                    %disp('bad link');
                    fprintf('bad link\n');
                end
                
                % GIVES A LIST OF LINKS TO CHECK 
                listOfLinks3 = parseForLinks(page3);
                
                if (checkForMatch(listOfLinks3, endPointer))
                    done = 1;
                    break;
                end
            end %% forloop b
        else
            done = 1;
            break;
        end %% links2
    end %% forloop a
else
    done = 1;
end %% links1

% DISPLAYS THE RESULT OF THE PROGRAM
if (done == 1)
    fprintf('\n\n\n***found a possible path***\n');
    disp(pointer1);
    if(~isempty(pointer2)) 
        disp(pointer2);
        t2=pointer2;
    else
        t2='n/a';
    end
    
    if(~isempty(pointer3))
        disp(pointer3);
        t3=pointer3;
    else
        t3='n/a';
    end
    
    disp(endPointer);
else
    fprintf('\n\n\n***could not find anything***\n');
end

%matlabpool close;
%end