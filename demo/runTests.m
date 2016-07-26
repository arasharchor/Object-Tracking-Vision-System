function runTests(p_varargin, fun_handles)
%***********************
% testharness
%***********************

if isempty(p_varargin)
    test_name = 'none';
else
    test_name = p_varargin{1};
end

% Decide which test(s) to run
execution_list = filterTests(test_name, fun_handles);

% Run tests
test_n = length(execution_list);
if test_n > 0
    for i = 1: test_n
        feval(execution_list{i});
    end
end


%%
function execution_list = filterTests(test_name, fun_handles)

% Generate a list of registered test names
registered_tests = ...
    cellfun(@(x)func2str(x), fun_handles, 'UniformOutput', false);

execution_list = {};
switch test_name
    case 'none'
        disp('===============');
        disp('Registered tests are:');
        cellfun(@(x) disp(x), registered_tests);        
    case 'all'
        execution_list = fun_handles;
    otherwise
        ind = find(strcmp(registered_tests, test_name));
        if ~isempty(ind)
            execution_list = {fun_handles{ind}};
        else
            disp(['***** ' test_name ' was not found in registered_tests.' ]);
        end
end
end
% runTests end
end