import numpy as np
from dwave_qbsolv import QBSolv

def import_graph(input_data_array, graph_file_name):
    with open(graph_file_name, 'r') as f:
        text = f.readlines()
        dim_x = len(text) #dim_x = number of rows in array of given file
        #print('the number of rows = ', dim_x)
        #print(text)
        #print('\n', '\n')

        for x in range(dim_x): #iterate through every row in the array
            char_list = (text[x]).split() #create a list of the numbers in the current row (list type = string)

            #print('row', x, ': ')
            #print(char_list)

            dim_y = len(char_list)  #dim_y = number of columns/values in current row
            if dim_x != dim_y:
                print('# of values in row ', x, ' not equal to column dimension ', dim_y)
                quit()

            for y in range(dim_y):  #iterate through every column in a single row
                input_data_array[x][y] = int(char_list[y])   #transfer 1D row data into 2D array of type = int

                #print('input_data_array[',x,'][',y,']', input_data_array[x][y])

        #print('input_data_array fully updated = ')
        #print(input_data_array)

    return input_data_array

def get_software_spins(graph_input_file):
    #initialize the graph array to all zeros
    input_graph = np.zeros((64,64), dtype=np.int8)
    #import graph to be solved
    input_graph = import_graph(input_graph, graph_input_file)

    #create dictionaries for the h and j coefficents
    h = {}
    j = {}

    #assign the input graph to the coefficents
    for x in range(62,3,-1):
        for y in range(59,63-x,-1):
            if ((input_graph[x,y] +input_graph[x-(y-(63-x)),y-(y-(63-x))]) != 0 ):
                j[(63-x, y)] = -1*(input_graph[x,y] + input_graph[x-(y-(63-x)),y-(y-(63-x))])

    # solve the problem and print the solution
    response = QBSolv().sample_ising(h,j, timeout=180)
    samples = list(response.samples())

    print(list(response.data_vectors['energy']))

    software_spins = []
    for s in samples:
        a = np.zeros(64)
        for k, v in s.items():
            a[k] = v
        software_spins.append(a)

    return software_spins
