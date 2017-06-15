function []= Ford()
clc;
clear all;
disp('Bellman-Ford Algorithm');
tn=input('Enter the number of Nodes: ');%we chose how many nodes we want
m = zeros(tn,tn);
char y ;%state the characters yes & no
char n;
for i=1:tn % create a matrix for route values
    for j=i+1:tn % matrix should be symetric 
        if i==j
            m(i,j)=0;% the main diagonal has to take price zero cause there is no value between the same nodes
        else
        fprintf('If Node %d and %d connected than enter Y otherwise N \n',i,j);% we choose if the possible 2 nodes are connected 
        chr_check = input('','s');
        check = strcmpi(chr_check,'Y'); % check the char if it is Y, means yes and we have to give a value
            if (check==1)
                fprintf('Enter Path value for Node %d and %d \n',i,j);% give a route value
                m(i,j)=input('');
                m(j,i)=m(i,j);
            else
                fprintf('means you are saying that Node %d and %d are not connected \n\n',i,j);% if char is not Y then the programm assumes that nodes are not connected
                m(i,j)=0;
                m(j,i)=0;
            end
        end
    end
    fprintf('\n \n');
end

bg=biograph(triu(m),[],'showarrows','off','ShowWeights','on','EdgeTextColor',[0 0 1]); %create the graph 
view(bg);
tt=1;
while(tt>=1)
    if tt~=1
        fprintf('\n If you Want to Change your path Value Matrix Enter 1, otherwise 0 \n'); 
        checkk = input(''); %state variable checkk
            if checkk == 1 %change path values randomly 
                fprintf('\nNow you have changed your Path Value Matrix \n');
                m=randi([1,10],tn); %it gives any random value to change path matrix
                bg=biograph(triu(m),[],'showarrows','off','ShowWeights','on','EdgeTextColor',[0 0 1]); %create new graph
                view(bg);
                for i=1:tn
                    m(i,i)=0;
                end
            elseif checkk==0 %terminate programm
                break;
            end
    end
tt=tt+1; %count how many times we run the loop 
k=1;
% define Edge number = [first node][second node]
    for i=1:tn
        for j=1:tn
            if m(i,j) ~= 0 % if edge not exit than skip that path
                edge(k,1) = i ;
                edge(k,2) = j;
                k=k+1;
            end
        end
    end
% first we consider that shortest of all node is infinity 999 except 1 for that value is zero
d(1)=0;
    for i=2:tn
        d(i)=999;
    end
% now we run loop and using Bellman -Ford method
% total no of Edges are = k-1
    for i=1:tn
        for j=1:k -1 % run loop for each path
            if (d(edge(j,2)) > d(edge(j,1))+m(edge(j,1),(edge(j,2)))) % if earlier value is greater than change it
                d(edge(j,2)) = d(edge(j,1))+m(edge(j,1),(edge(j,2)));
                lastlabel(edge(j,2)) =edge(j,1);
            end
        end
    end
fprintf(' \n Shortest path values are from Node 1 \n Label(Destination) = [Total path value, Predessor Node]\n') % printing shortest path
    for i=1:tn
        fprintf(' Label( %d ) = [ %d , %d ] \n ',i,lastlabel(i),d(i));
    end
fprintf('\n You are running your Code %d time \n',tt-1);

end

end