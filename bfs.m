 
function [searchNodes,iterations] = bfs(starting,ending,Nodenames,startNode)


    iterations = table;
    
    % Refactor starting, ending, Nodenames & startNode vectors to numbers
    
    % If Nodenames argument missing 
    if (nargin<4)
        
        % Third argument (i.e. Nodenames) is starting Node
        startingNode = Nodenames;
        
        [s,e,n,sNode] = refactor(starting,ending,startingNode);
        
    else
        
        % Fourth argument (i.e. startNode) is starting Node
        startingNode = startNode;
        
        [s,e,n,sNode] = refactor(starting,ending,Nodenames,startingNode);        
        
    end

    
    % Get all unique nodes from starting and ending vectors
    uniqueNodes = getNodes(s,e);
      G = digraph(s,e);
      plot(G)
    % Initialize visited list and stack
    visited = [];
    stack = [];
    % Set starting node as current node and add it in to visited list
    currentNode = sNode;
    visited = [visited sNode];
    % Local variables to track iteration number
    iteration = 1;   
    % Update Iterations table
    iterations = [iterations; updateTable(s,e,n,currentNode,stack,visited,iteration,'Starting Node')];
    % Repeat until stack is empty
    while(~isempty(currentNode))
        
        % Get all Pops of current node
        Pops = getPops(s,e,currentNode);

        for i=1:length(Pops)
           
            

            % If new unvisited Pop found add it in stack and visited list
            if(length(find(visited==Pops(i)))==0)

                stack = [stack Pops(i)];
                visited = [visited Pops(i)];
                
                % Increase iteration number
                iteration = iteration + 1;
                iterations = [iterations; updateTable(s,e,n,currentNode,stack,visited,iteration,strcat('Unvisited node found ',n(Pops(i))))];

            end          

        end
         
              
         
        % If no new Pop found for current node then remove first item
        % from stack and make it as current node
        if (length(stack)>0)            
            currentNode = stack(1);
            stack(1) = [];
            
            
            comments = strcat('Destack ',n(currentNode),' from stack');
            
            
            iteration = iteration + 1;
            iterations = [iterations; updateTable(s,e,n,currentNode,stack,visited,iteration,comments)];
        else
            currentNode = [];
        end
        
               
         
    end
    
    
    % Update iteration table for last state of stack, visited list, current
    % node and search path when after stack is empty
    if(iteration > 0)
        
        iteration = iteration +1;
        
        iterations = [iterations; updateTable(s,e,n,currentNode,stack,visited,iteration,'BFS Converged')];

    end
    
    searchNodes = n(visited);
    iterations.Properties.VariableNames = {'Iteration' 'CurrentNode' 'Queue' 'Visited' 'Comments'};
    
        
end




function Pops = getPops(starting,ending,node)
    
    Pops = sort(ending(find(starting==node)));
    
end



function nodes = getNodes(s,e)

    nodes = unique(horzcat(s,e));

end


function [s,e,n,sn] = refactor(starting,ending,Nodenames,startNode)

    % If Nodenames argument missing 
    if (nargin<4)
        
        % Third argument (i.e. Nodenames) is starting Node
        sn = Nodenames;

    else
        
        % Fourth argument (i.e. startNode) is starting Node
        sn = startNode;  
        
    end

    
    % Get all unique nodes
    uNodes = unique(horzcat(starting,ending));
        
        
    
    % If starting and ending are cell arrays
    if(iscell(starting) && iscell(ending))
    
        % If Nodenames argument missing
        if(nargin<4)
            n = uNodes;
        else
            n = Nodenames;
        end
        
        
        % Get unique nodes cell array
        uNodes = unique(horzcat(starting,ending));

        s = [];
        e = [];

        % Populate starting and ending with equivalent numeric values

        for i=1:length(starting)
            [sFound,sIndex] = ismember(starting(i),uNodes);
            [tFound,tIndex] = ismember(ending(i),uNodes);
            s = [s sIndex];
            e = [e tIndex];
        end
            
        
        
        
    else
        
        s = starting;
        e = ending;
        
        % If Nodenames argument missing
        if(nargin<4)    
            
            uNodes = unique(horzcat(starting,ending));
            n = cell(1,length(uNodes));
            
            
            for i=1:length(uNodes)
                n{i} = num2str(uNodes(i));
            end
            
        else
            n = Nodenames;
        end
    end
    
    
    
    % If starting node is not a number
    if(~isnumeric(sn))

        sn = find(ismember(n,sn));
        
    end

end



function tableIteration = updateTable(s,e,n,currentNode,stack,visited,iteration,comments)

   
    uniqueNodes = getNodes(s,e);


    % Display current stack

    stackStr = '[';
    
    for i=length(stack):-1:1
        if(i==1)
            stackStr = strcat(stackStr,sprintf('%s',char(n(find(uniqueNodes==stack(i))))));
        else
            stackStr = strcat(stackStr,sprintf('%s ',char(n(find(uniqueNodes==stack(i))))));
        end
    end
    stackStr = strcat(stackStr,sprintf(']'));
    
    

    % Display current visited list     

    visitedStr = '[';
    
    for i=1:length(visited)
        if(i==length(visited))
            visitedStr = strcat(visitedStr,sprintf('%s',char(n(find(uniqueNodes==visited(i))))));
        else
            visitedStr = strcat(visitedStr,sprintf('%s ',char(n(find(uniqueNodes==visited(i))))));
        end
    end
    
    visitedStr = strcat(visitedStr,sprintf(']'));


    % Display current node
    if(~isempty(currentNode))
        node = n(currentNode);        
        currentNodeStr = sprintf('[%s]',node{1,1}(1,1));
    else
        currentNodeStr = sprintf('[]');
    end

    array = {iteration currentNodeStr stackStr visitedStr comments};
    tableIteration = cell2table(array);

end