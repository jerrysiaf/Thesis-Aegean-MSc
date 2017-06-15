

function [searchNodes,iterations] = dfs(starting,ending,Nodenames,startNode)

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
    % Visualise graph 
    G = digraph(s,e);
      plot(G)
    % Create visited and queue list
    visited = [];
    stack = [];
    % Set starting node as current node and add it in to stack and visited list
    currentNode = sNode;
    stack = [sNode stack];
    visited = [visited sNode];
    % Local variables to track iteration number
    iteration = 1;   
    % Update Iterations table
    iterations = [iterations; updateTable(s,e,n,currentNode,stack,visited,iteration,'Starting Node')];
    % Repeat until stack is empty
    while(~isempty(currentNode))
        % Get all Pops of current node
        Pops = getPops(s,e,currentNode);
        
        
        newPopFound = 0;
            
        for i=1:length(Pops)
               

            % If new unvisited Pop found add it in stack and visited list
            if(isempty(find(visited==Pops(i), 1)))

                stack = [Pops(i) stack];
                visited = [visited Pops(i)];
                currentNode = Pops(i);
                
                % Increase iteration number
                iteration = iteration + 1;
                iterations = [iterations; updateTable(s,e,n,currentNode,stack,visited,iteration,strcat('Unvisited node found ',n(currentNode)))];
                
                newPopFound = 1;
                
                break;

            end

        end
        
        % If no new Pop found for current node then remove last it from stack and make it as current node
        if (newPopFound == 0)            
            comment = '';
            popedItem = [];
            if(~isempty(stack))
                popedItem = stack(1);
                stack(1) = [];
            end
            if(~isempty(stack))
                currentNode = stack(1);
                comment = strcat('Pop node from stack ',n(popedItem));
            else
                currentNode = [];
                comment = 'DFS Converged';
            end 
            iteration = iteration + 1;
            iterations = [iterations; updateTable(s,e,n,currentNode,stack,visited,iteration,comment)];
   
        end
        
    end
 
    searchNodes = n(visited);
    iterations.Properties.VariableNames = {'Iteration' 'CurrentNode' 'Stack' 'Visited' 'Comments'};
  
end

function Pops = getPops(starting,ending,node)
    
    Pops = sort(ending(starting==node));
    
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
            [~,sIndex] = ismember(starting(i),uNodes);
            [~,tIndex] = ismember(ending(i),uNodes);
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


    % Display current queue

    stackStr = '[';
    
    for i=length(stack):-1:1
        if(i==1)
            stackStr = strcat(stackStr,sprintf('%s',char(n(uniqueNodes==stack(i)))));
        else
            stackStr = strcat(stackStr,sprintf('%s ',char(n(uniqueNodes==stack(i)))));
        end
    end
    stackStr = strcat(stackStr,sprintf(']'));
    
    

    % Display current visited list     

    visitedStr = '[';
    
    for i=1:length(visited)
        if(i==length(visited))
            visitedStr = strcat(visitedStr,sprintf('%s',char(n(uniqueNodes==visited(i)))));
        else
            visitedStr = strcat(visitedStr,sprintf('%s ',char(n(uniqueNodes==visited(i)))));
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