import numpy as np
import random
import math


#------------------FUNCTIONS--------------------------#

#Purpose: generates random 64x64 graph for COBI/COBIFREEZE chip containing a user-defined
    # density and problem size to the text file of choice
def create_graph(problem_size, starting_array, text_file_name, density_dec):
    #check input values:
    problem_size = abs(int(problem_size))   #make sure problem size is a valid number/option
    if problem_size > 59:
        problem_size = 59                   #max possible problem size for 64x64 array
    print('problem_size = ', problem_size)

    density_dec = abs(float(density_dec))   #account for mistakes in defining density parameter
    if density_dec > 1.0:
        print('density parameter should be a value in range [0.0, 1.0]')
        print('density parameter changed to 1.0')
        density_dec = 1.0

    #------------------------------------------------------------

    if (problem_size == 0) or (density_dec == 0):
        starting_array = complete_diagonal(starting_array)
    else:
        starting_array = assign_weights(problem_size, starting_array, density_dec)   #populate all cells within problem region of array
        starting_array = enable_cells(starting_array, problem_size, density_dec)   #turn on enable cells for delay cells and rows/cols within problem region
        starting_array = complete_diagonal(starting_array)  #fill in remaining cells along the diagonal with weight value of +7
        find_unused_nodes(starting_array, problem_size)    #check if any nodes not used and print actual density of smaller problem if unused nodes present

    with open(text_file_name, 'w') as f:    #write finished array to text file
        for x in range(64):
            '''f.write('row ')
            f.write(str(x))
            f.write(':')
            f.write('\n')'''
            for y in range(64):
                if starting_array[x,y] < 0:     #adjust spacing to create more organized text file
                    f.write(' ')
                else:
                    f.write('  ')
                f.write(str(starting_array[x,y]))
            
            f.write('\n')

#Purpose: fill all cells within problem size with a non-zero weight except the diagonal,
    #then randomly change upper triangle cells (and lower triangle counterpart cells) with 0s
    # until user-defined density is reached
def assign_weights(prob_size, initial_array, density_percent):

    total_0_rows = 63 - prob_size       #number of delay cells (== 4) + number of unused rows/cols

    y_diag = prob_size                  #initalize for first loop (set to y-location in upper right corner of weight graph/array)

    #populate upper and lower triangle of weights within array dimensions
    for x in range(total_0_rows,63,1):  #note: HWL[63] = enable row

        for y in range(1,(prob_size+1),1):  #note: VWL[1] = enable col
            if (y < y_diag): #random values only for weights in problem size array excluding the diagonal
                #weight_val = random.randint(-14,14)
                weight_val = random.randint(-14,14)

                while weight_val == 0:      #make sure all cells == non-zero values (100% density)
                    #weight_val = random.randint(-14,14)
                    weight_val = random.randint(-14,14)
                
                initial_array[x,y] = math.ceil(weight_val/2.0)

                diag_distance = y_diag - y
                initial_array[(x+diag_distance), y_diag] = math.floor(weight_val/2.0)  # approx. equal value for cell that mirrors [x,y]
        
        y_diag = y_diag - 1 #get column of next diagonal cell

    initial_array = reach_density(prob_size, initial_array, density_percent)

    return initial_array

#Purpose: change random cells within problem region of array to 0 to reach
    # user-defined density (density <= 1.00)
def reach_density(prob_dim, modify_array, density):
    total_0_rows = 63 - prob_dim       #equal to number of delay cells (== 4) + number of unused rows/cols
    
    random_weights = (prob_dim * (prob_dim - 1)) * 0.5        #total cells in upper triangle of array (w/o diagonal) that can be any number
    
    density_0s = 1.0 - density
    num_0s_required = int(round(random_weights * density_0s))      #number of 0s needed to reach the given density level
    num_0s = 0      #initial number of 0s in array (graph starts with 100% density)

    print('current density for', prob_dim,'node graph = ', ((random_weights - num_0s_required)/random_weights))

    while num_0s < num_0s_required:
        rand_x = random.randint(total_0_rows, 62)
        rand_y = random.randint(1, prob_dim)

        y_diag = 63 - rand_x
        diag_distance = y_diag - rand_y
        if diag_distance < 0:   # counting number of 0s only in upper triangle, so if [rand_x, rand_y] is in lower triangle, generate a new position
            continue

                #initial_array[(rand_x + diag_distance), y_diag] = math.floor(weight_val/2.0)  # approx. equal value for cell that mirrors [x,y]

        if rand_y != y_diag:
            if (modify_array[rand_x, rand_y] != 0) or (modify_array[(rand_x + diag_distance), y_diag] != 0):
                modify_array[rand_x, rand_y] = 0
                modify_array[(rand_x + diag_distance), y_diag] = 0
                num_0s = num_0s + 1
    
    return modify_array

#Purpose: turn on rows/columns in HWL 63 and VWL 0 if they contain at least 1 non-zero weights
def enable_cells(graph_array, problem_dim,  dens_dec):
    y_diag = 64
    total_0_rows = 63 - problem_dim

    for x in range(0,64,1):
        y_diag = y_diag - 1

        if x >= total_0_rows:

            for y in range(1,(problem_dim+1),1):
                if y < y_diag:      #look at coordinate pairs between upper and lower triangle
                    diag_dist = y_diag - y

                    #look at only rows or columns that have not been turned on
                    if (graph_array[x,0] == 0) or (graph_array[63,y] == 0) or (graph_array[(x+diag_dist),0] == 0) or (graph_array[63,y_diag] == 0):

                        if (graph_array[x,y] != 0) or graph_array[(x+diag_dist), y_diag] != 0: #cell not along diagonal and is non-zero or has non-zero counterpart

                            graph_array[x,0] = 1    #enable row specific to upper triangle [x,y] location
                            graph_array[63,y] = 1   #enable column specific to upper triangle [x,y] location

                            graph_array[(x+diag_dist), 0] = 1   #enable row specific to lower triangle mirror coordinate [x+diag_dist, y_diag]
                            graph_array[63,y_diag] = 1          #enable column specific to lower triangle mirror coordinate [x+diag_dist, y_diag]
    
    return graph_array

#Purpose: fill in all diagonal cells with number 7
def complete_diagonal(grid_array):
    y_diag = 64
    for x in range(64):
        y_diag = y_diag - 1
        if grid_array[x, y_diag] != 7:
            grid_array[x, y_diag] = 7
    
    return grid_array

#Purpose: check if any nodes not used in problem, and recalculate actual density taking
    #any diabled nodes or 0/1 pairs or 0/-1 weight pairs into account
def find_unused_nodes(prob_array, graph_size):
    print('checking for any unused nodes:')
    total_0_rows = 63 - graph_size
    unused_nodes = 0
    used_cells = 0
    count_0s = 0
    weight_non_0 = 0
    for x in range(total_0_rows, 63, 1):    #not checking outside of problem region for any enabled cells - just checking within problem
        if prob_array[x,0] == 0:
            unused_nodes = unused_nodes + 1     #just check disabled HWL cells because it's the same num as VWL

        y_diag = 63-x
        for y in range(1, (graph_size + 1), 1):
            if y != y_diag:
                if ((prob_array[x,0] == 1) and (prob_array[63,y] == 1)):
                    if prob_array[x,y] == 0:        #counting any enabled 0 - can be a 0 in 0,0 or 0,1 or 0,-1 paired/mirror weights
                        #print('coordinate = [', x, y, ']:', prob_array[x,y])
                        count_0s = count_0s + 1
                        #print('count_0s + 1 = ', count_0s)
                    else:
                        #print('coordinate = [', x, y, ']:', prob_array[x,y])
                        weight_non_0 = weight_non_0 + 1
                        #print('weight_non_0 + 1 = ', weight_non_0)

    print('count_0s = ', count_0s)
    used_cells = count_0s + weight_non_0
    print('used_cells = ', used_cells, '\n')
    print('found', unused_nodes, 'unused_nodes', '\n')

    print('final node size = ', graph_size - unused_nodes)
    print('final density = ', (1.0 * weight_non_0 / used_cells))
    if unused_nodes == 0:
        print('Deviations from user-defined density due to inclusion of 0s from 0/1 and 0/-1 mirror pairs in count_0s', '\n')
    else:
        print('Deviations from user-defined density due to low density - random density did not turn on all problem nodes', '\n')


#------------- EXECUTE CODE -----------------#
problem_array = np.zeros((64,64), dtype=np.int8)

create_graph(24, problem_array, 'test.txt', 0.8)
print(problem_array)
#create_graph parameters: create_graph(problem_size,starting_array, text_file_name, density_dec)
    #problem_size = any integer in range of [0:59], if a number > 59 is listed, code overrides and lists 59 as problem size
    #starting_array = 64x64 integer array initialized to 0 that user wants to use to populate graph to
    #text_file_name = list name of file and location to send file if applicable
    #density_dec = density of non-zero numbers in graph, if not written in decimal format, code adjusts as needed



#Graph info =
    #64x64
    #VWL[0], HWL[63] = ENABLE
    #HWL[0:3], VWL[60:63] = DELAY
    #diagonal +7 is a negative slope (downwards to the right such as '\') on positive x-y plane

#Graph Requirements
    #max problem size = 59 nodes
    #maximum array size = 64x64
    #4 rows, 4 cols == delay nodes
    #1 row (HWL[63]), 1 col (VWL[0]) == enable nodes
        #cell in HWL[63] or VWL[0] set to +1 IF
            # any col going through HWL[63] or row through VWL[0]
                # have non-zero value (excluding diagonal) 
    #diagonal cells always == +7