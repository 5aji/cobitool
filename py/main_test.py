#initial set up
import numpy as np
import RPi.GPIO as GPIO
import sys
import time
#np.set_printoptions(threshold=sys.maxsize)

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
#--------------------PIN INITIALIZATION--------------------#

#set up pin names
weight_2 = 2
weight_3 = 3
scanout_clk = 4
sample_clk = 17
all_row_hi = 27
weight_1 = 22
weight_en = 10
col_addr_4 = 9
addr_en64_chip1 = 11
col_addr_3 = 5
col_addr_1 = 6
col_addr_0 = 13
row_addr_2 = 19
row_addr_3 = 26
weight_5 = 14
scanout_dout64_chip2 = 15
scanout_dout64_chip1 = 18
weight_0 = 23
rosc_en = 24
col_addr_5 = 25
row_addr_5 = 8
addr_en64_chip2 = 7
weight_4 = 1
col_addr_2 = 12
row_addr_1 = 16
row_addr_0 = 20
row_addr_4 = 21
#---------------PIN INITIALIZATION CONTIUNED...---------------#

#set pinmodes
GPIO.setup(weight_2, GPIO.OUT)
GPIO.setup(weight_3, GPIO.OUT)
GPIO.setup(scanout_clk, GPIO.OUT)
GPIO.setup(sample_clk, GPIO.OUT)
GPIO.setup(all_row_hi, GPIO.OUT)
GPIO.setup(weight_1, GPIO.OUT)
GPIO.setup(weight_en, GPIO.OUT)
GPIO.setup(col_addr_4, GPIO.OUT)
GPIO.setup(addr_en64_chip1, GPIO.OUT)
GPIO.setup(col_addr_3, GPIO.OUT)
GPIO.setup(col_addr_1, GPIO.OUT)
GPIO.setup(col_addr_0, GPIO.OUT)
GPIO.setup(row_addr_2, GPIO.OUT)
GPIO.setup(row_addr_3, GPIO.OUT)
GPIO.setup(weight_5, GPIO.OUT)
GPIO.setup(scanout_dout64_chip2, GPIO.IN)
GPIO.setup(scanout_dout64_chip1, GPIO.IN)
GPIO.setup(weight_0, GPIO.OUT)
GPIO.setup(rosc_en, GPIO.OUT)
GPIO.setup(col_addr_5, GPIO.OUT)
GPIO.setup(row_addr_5, GPIO.OUT)
GPIO.setup(addr_en64_chip2, GPIO.OUT)
GPIO.setup(weight_4, GPIO.OUT)
GPIO.setup(col_addr_2, GPIO.OUT)
GPIO.setup(row_addr_1, GPIO.OUT)
GPIO.setup(row_addr_0, GPIO.OUT)
GPIO.setup(row_addr_4, GPIO.OUT)

#------------------------DICTIONARY-------------------------#
GPIO.output(sample_clk, GPIO.LOW)

#------------------------DICTIONARY-------------------------#
#dictionary of iterative pins used in addressing for chip programming
#dictionary values used only when required to iterate through a loop
dict_graph_addr = {
  0:'row_addr_0', 1:'row_addr_1', 2:'row_addr_2',  3:'row_addr_3',
  4:'row_addr_4', 5:'row_addr_5', 6:'col_addr_0',  7:'col_addr_1',
  8:'col_addr_2', 9:'col_addr_3', 10:'col_addr_4', 11:'col_addr_5',
  12:'weight_0',  13:'weight_1',  14:'weight_2',   15:'weight_3',
  16: 'weight_4', 17: 'weight_5'}

#------------------------ FUNCTIONS ------------------------#
#Purpose: test to check if correct data is received from QFN chip
def scanchaintest(all_row_hi, scanout_clk, scanout_dout64_chip1, scanout_dout64_chip2):
    GPIO.output(sample_clk, GPIO.LOW)

    x = 0
    while(x != 5000):
        x= x + 1
        GPIO.output(all_row_hi, GPIO.HIGH)
        print(GPIO.input(scanout_dout64_chip1))
        print(GPIO.input(scanout_dout64_chip2))
        GPIO.output(scanout_clk, GPIO.HIGH)
        GPIO.output(scanout_clk, GPIO.LOW)

        GPIO.output(all_row_hi, GPIO.LOW)
        print(GPIO.input(scanout_dout64_chip1))
        print(GPIO.input(scanout_dout64_chip2))
        GPIO.output(scanout_clk, GPIO.HIGH)
        GPIO.output(scanout_clk, GPIO.LOW)
        #print('\n 1 iteration complete \n')

#Purpose: take text file of graph data and input it into an array
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


#Purpose: take initial imported array and adjust weights to
    # corresponding pins and enter new values in a float array
def modify_array_for_pins(initial_array, final_pin_array, problem_size):
    
    final_pin_array = initial_array.copy()
    total_0_rows = 63 - problem_size    #number of delay cells (== 4) + number of unused rows/cols; the first non-zero row
    y_diag = problem_size   #set to y-location at upper right corner of problem region
    
    #part 1: adjust all values within problem regions of array
    for x in range(total_0_rows,63,1):      #x/y ranges iterate through problem regions of array

        for y in range(1,(problem_size+1), 1):
            integer_pin = initial_array[x,y]
            if integer_pin == -7:
                final_pin_array[x,y] = 0b001110     # load value of 14.0 to final_array

            elif integer_pin == -6:
                final_pin_array[x,y] = 0b001100     # load value of 12.0 to final_array
            
            elif integer_pin == -5:
                final_pin_array[x,y] = 0b001010     # load value of 10.0 to final_array

            elif integer_pin == -4:
                final_pin_array[x,y] = 0b001000     # load value of 8.0 to final_array
            
            elif integer_pin == -3:
                final_pin_array[x,y] = 0b000110     # load value of 6.0 to final_array

            elif integer_pin == -2:
                final_pin_array[x,y] = 0b000100     # load value of 4.0 to final_array
                
            elif integer_pin == -1:
                final_pin_array[x,y] = 0b000010     # load value of 2.0 to final_array
                        
            elif integer_pin == 0:
                final_pin_array[x,y] = 0b000000     # load value of 0.0 to final_array
                
            elif integer_pin == 1:
                final_pin_array[x,y] = 0b000011     # load value of 3.0 to final_array
                
            elif integer_pin == 2:
                final_pin_array[x,y] = 0b000101     # load value of 5.0 to final_array

            elif integer_pin == 3:
                final_pin_array[x,y] = 0b000111     # load value of 7.0 to final_array

            elif integer_pin == 4:
                final_pin_array[x,y] = 0b001001     # load value of 9.0 to final_array
                        
            elif integer_pin == 5:
                final_pin_array[x,y] = 0b001011     # load value of 11.0 to final_array
            
            elif integer_pin == 6:
                final_pin_array[x,y] = 0b001101     # load value of 13.0 to final_array
                
            elif integer_pin == 8:
                final_pin_array[x,y] = 0b011111     #load the strong positive coupling to the final_array
     
            elif integer_pin == -8:
                final_pin_array[x,y] = 0b111110     #load the strong negative coupling to the final_array
                
            else:                   #integer_pin == 7
                if y == y_diag:     #along diagonal
                    final_pin_array[x,y] = 0b011111 # load value of 31.0 to final_array
                else:
                    final_pin_array[x,y] = 0b001111 # load value of 15.0 to final_array
        
        y_diag = y_diag - 1

    #part 2 - adjust remaining 7s in diagonal
    y_diag = problem_size
    for x in range (0,64, 1):

        for y in range(0,64,1):
            integer_pin = initial_array[x,y]
            if (y == y_diag) and (integer_pin == 7):
                final_pin_array[x,y] = 0b011111

    return final_pin_array

#Purpose: convert each value in integer/floating-point arrays (row, column, and graph/weights)
    # to binary and send addresses/values to set up chip
def program_chip(data_array, enable_pin_name):

    #initialize binary lists
    bin_row_list = np.empty(6, dtype=str)
    bin_col_list = np.empty(6, dtype=str)
    bin_weight_list = np.empty(6, dtype=str)

    #reset pins for programming
    weight_pins_low()
    GPIO.output(all_row_hi, GPIO.LOW)

    for x in range(64): #run through each row of 64x64 cells in COBI/COBIFREEZE
        bin_row_list = binary_splice_rev(x, bin_row_list)   #upload binary equivalent to a list in reverse order (row)
        for y in range(64): #run through each cell in a given row
            bin_col_list = binary_splice_rev(y, bin_col_list)
            bin_weight_list = binary_splice_rev(data_array[x][y], bin_weight_list)

            #set address of 1 cell
            set_addr(0, bin_row_list) #assign the row number; 0 = index where row names in dictionary begin
            set_addr(6, bin_col_list) #assign the column number; 6 = index where col names in dictionary begin

            GPIO.output(enable_pin_name, GPIO.HIGH)
            
            #set weight of 1 cell
            set_addr(12, bin_weight_list) #assign the weight corresponding to current cell
            time.sleep(.001)
            GPIO.output(enable_pin_name, GPIO.LOW)
            weight_pins_low()   #reset for next address


#takes a number from the imported graph array - converts to binary, 
#places each bit of binary number in a list in reverse order
def binary_splice_rev(num, bin_list):
    bin_version = format(num, '06b')
    for char in range(6):
        bin_list[5-char] = bin_version[char]
    return bin_list

#Purpose: turn a number of weight pins low
def weight_pins_low():
    GPIO.output(weight_0, GPIO.LOW)
    GPIO.output(weight_1, GPIO.LOW)
    GPIO.output(weight_2, GPIO.LOW)
    GPIO.output(weight_3, GPIO.LOW)
    GPIO.output(weight_4, GPIO.LOW)
    GPIO.output(weight_5, GPIO.LOW)

#Purpose: use binary values from binary_splice_rev function and send through RPi pins
def set_addr(correction, bin_num_list):
    for i in range(6):
        addr_name = dict_graph_addr[i + correction]
        #print(str(addr_name) + ' ' +str(bin_num_list[i]))
        if bin_num_list[i] == '1':
            GPIO.output(globals()[addr_name], GPIO.HIGH)
        else:
            GPIO.output(globals()[addr_name], GPIO.LOW)


#Purpose: write results from both chips to 2 separate text files
def sample_store(chip1_file_name, chip2_file_name,sample_times):
    all_samples_chip1 = np.zeros((504,sample_times), dtype=np.int8)
    all_samples_chip2 = np.zeros((504,sample_times), dtype=np.int8)
    
    GPIO.output(all_row_hi, GPIO.HIGH)   #reset for sampling
    GPIO.output(scanout_clk, GPIO.LOW) #clk low for sampling

    GPIO.output(weight_en, GPIO.LOW)   #reset weights to randomize spins
    GPIO.output(weight_en, GPIO.HIGH)   #reset weights to randomize spins
    
    
    for sample in range(sample_times):
        GPIO.output(weight_en, GPIO.LOW)
        GPIO.output(weight_en, GPIO.HIGH)
        
        GPIO.output(sample_clk, GPIO.HIGH)
        
        GPIO.output(sample_clk, GPIO.LOW)
        for bit in range(504):
            #if (sample == 1) and (bit < 64):
                #print(GPIO.input(scanout_dout64_chip1))
            if GPIO.input(scanout_dout64_chip1) == 1:
                all_samples_chip1[bit][sample] = 1
            else:
                all_samples_chip1[bit][sample] = 0
            if GPIO.input(scanout_dout64_chip2) == 1:
                all_samples_chip2[bit][sample] = 1
            else:
                all_samples_chip2[bit][sample] = 0
            
            if (bit == 503) and (sample == (sample_times - 1)):
                break
            
            GPIO.output(scanout_clk, GPIO.HIGH)
            time.sleep(.000001)
            GPIO.output(scanout_clk, GPIO.LOW)


    with open(chip1_file_name, 'w') as f1, open(chip2_file_name, 'w') as f2:
        count_node_rows = 0
        for bit in range(504):
            if (bit % 8) == 0:
                f1.write('test.txt line ')
                f1.write(str((count_node_rows+1)))
                f1.write(':')
                f1.write('\n')
                f2.write('node ')
                f2.write(str((62 - (count_node_rows))))
                f2.write(':')
                f2.write('\n')
                count_node_rows = count_node_rows + 1
            for sample in range(sample_times):
                f1.write(str(all_samples_chip1[bit][sample]))
                f2.write(str(all_samples_chip2[bit][sample]))
                
                if sample < (sample_times - 1):
                    f1.write('   ')
                    f2.write('   ')
                    
            if bit == 503:
                break
            
            f1.write('\n')
            f2.write('\n')
            
            if (bit % 8) == 7:    #organize text file format
                f1.write('\n')
                f2.write('\n')
                
    GPIO.output(all_row_hi, GPIO.LOW) 

            
def change_single_SRAM_cell(vwl,hwl,wbl):
    #initialize binary lists
    bin_row_list = np.empty(6, dtype=str)
    bin_col_list = np.empty(6, dtype=str)
    bin_weight_list = np.empty(6, dtype=str)

    #reset pins for programming
    weight_pins_low()
    GPIO.output(all_row_hi, GPIO.LOW)
    
    #create empty list for programming
    bin_row_list = binary_splice_rev(hwl, bin_row_list)
    bin_col_list = binary_splice_rev(vwl, bin_col_list)
    wbl_modified = weight_modification(wbl)
    bin_weight_list = binary_splice_rev(wbl_modified, bin_weight_list)

    #set address of 1 cell
    set_addr(0, bin_row_list) #assign the row number; 0 = index where row names in dictionary begin
    set_addr(6, bin_col_list) #assign the column number; 6 = index where col names in dictionary begin

    GPIO.output(addr_en64_chip1, GPIO.HIGH)
    GPIO.output(addr_en64_chip2, GPIO.HIGH)

    #set weight of 1 cell
    set_addr(12, bin_weight_list) #assign the weight corresponding to current cell
    time.sleep(.001)
    GPIO.output(addr_en64_chip1, GPIO.LOW)
    GPIO.output(addr_en64_chip2, GPIO.LOW)

    weight_pins_low()   #reset for next address    

def weight_modification(weight):
    integer_pin = weight
    modified_weight = 0
    
    if integer_pin == -7:
        modified_weight = 0b001110     # load value of 14.0 to final_array

    elif integer_pin == -6:
        modified_weight = 0b001100     # load value of 12.0 to final_array
    
    elif integer_pin == -5:
        modified_weight = 0b001010     # load value of 10.0 to final_array

    elif integer_pin == -4:
        modified_weight = 0b001000     # load value of 8.0 to final_array
    
    elif integer_pin == -3:
        modified_weight = 0b000110     # load value of 6.0 to final_array

    elif integer_pin == -2:
        modified_weight = 0b000100     # load value of 4.0 to final_array
        
    elif integer_pin == -1:
        modified_weight = 0b000010     # load value of 2.0 to final_array
                
    elif integer_pin == 0:
        modified_weight = 0b000000     # load value of 0.0 to final_array
        
    elif integer_pin == 1:
        modified_weight = 0b000011     # load value of 3.0 to final_array
        
    elif integer_pin == 2:
        modified_weight = 0b000101     # load value of 5.0 to final_array

    elif integer_pin == 3:
        modified_weight = 0b000111     # load value of 7.0 to final_array

    elif integer_pin == 4:
        modified_weight = 0b001001     # load value of 9.0 to final_array
                
    elif integer_pin == 5:
        modified_weight = 0b001011     # load value of 11.0 to final_array
    
    elif integer_pin == 6:
        modified_weight = 0b001101     # load value of 13.0 to final_array

    return modified_weight
    

def pair_full_calibration():
    for w in range(0,8):
        change_single_SRAM_cell(1,0,w)
        for x in range(0,8):
            change_single_SRAM_cell(2,0,x)
            for y in range(0,8):
                change_single_SRAM_cell(62,62,y)
                for z in range(0,8):
                    change_single_SRAM_cell(63,62,z)
                    chip1_file_name = './chip1_calibration_samples/chip_sample_162_262_163_263_' + str(w) + '_' + str(x) + '_' + str(y) + '_' + str(z)  
                    chip2_file_name = './chip2_calibration_samples/chip_sample_162_262_163_263_' + str(w) + '_' + str(x) + '_' + str(y) + '_' + str(z)  
                    sample_store(chip1_file_name, chip2_file_name,50)
                    print(str(w) + '_' + str(x) + '_' + str(y) + '_' + str(z))

def add_calibrated_cells(input_graph):
    updated_graph = input_graph
    calibrated_graph = np.zeros((64,64), dtype=np.int8)
    calibrated_graph = import_graph(calibrated_graph, 'calibrated_graph_1.txt')
    for x in range(0,4):
        for y in range(0,64):
            updated_graph[x][y] = calibrated_graph[x][y]
    
    for x in range(0,64):
        for y in range(60,64):
            updated_graph[x][y] = calibrated_graph[x][y]
    
    
    return updated_graph

def file_parse_post_processing(chip1_file_name,rosc1,samples):
	with open(chip1_file_name, 'r') as f1:
		chip1_lines = f1.readlines()
	
	#choose parts of the file we want
	rosc0_list = []
	rosc1_list = []
	#print(len(chip1_lines))
	for x in range(0,8):
		rosc1_list.append(chip1_lines[10*rosc1+x+1].replace(" ", ""))
		
	#print(rosc1_list)
    
	count_total= 0
	for x in range(0,samples):
		count = 0
		for y in range(0,8):
			if(rosc1_list[y][x] == '0'):
				count = count + 1
		
		if(count > 5):
			count_total = count_total + 1
		
	return count_total

def apply_calibration(graph_array):
    temp_graph = np.copy(graph_array)
    
    with open("best_list.txt", 'r') as f:
        lines_out  = f.readlines()
    f.close()    
    
    for x in range(0,58):
        delay = lines_out[x].split(",")
        delay = int(delay[1])
        temp_graph = set_rosc_delay(x,delay,temp_graph)
        
    return temp_graph

def brute_automation(graph_array,samples):
    best_list = open("best_list.txt", "w")
    full_list = open("full_list.txt", "w")
    standard_template_graph = graph_array
    
    for x in range(0,58):
        print(x+1)
        count_best = 0
        temp_graph = np.zeros((64,64), dtype=np.int8)
        temp_graph = np.copy(standard_template_graph)
        
        
        #enable bits turned high
        temp_graph[63][2+x] = 1
        temp_graph[61-x][0] = 1
        
        #weight bits set to +1
        temp_graph[62][2+x] = 1
        temp_graph[61-x][1] = 1
        
        
        
        for y in range(0,28):
            adjusted_graph_array_temp = np.zeros((64,64), dtype=np.int8)
            temp_graph = set_rosc_delay(x,y,temp_graph)
            
            
            
            adjusted_graph_array_temp = np.copy(modify_array_for_pins(temp_graph, adjusted_graph_array_temp, 59))
            program_chip(adjusted_graph_array_temp, addr_en64_chip1)
            sample_store('raw_data/chip1_test' + str(x+1) + 'count' + str(y) +'.txt', 'chip1_test.txt', samples)
            count_total = file_parse_post_processing('raw_data/chip1_test' + str(x+1) + 'count' + str(y) +'.txt',61-x,samples)
            full_list.write('node' + str(x+1) + 'calibration' + str(y) + 'counttotal,'+ str(count_total)+ '/n')
            
            if count_total > count_best:
                count_best = count_total
                count_best_string = 'node' + str(x+1) + 'count,' + str(y)
        
        print(count_best_string + ' best count =' + str(count_best))
        best_list.write(count_best_string + '/n')

def set_rosc_delay(x,rosc_delay,a):
    temp_graph = a
    if(rosc_delay < 8):
        temp_graph[3][2+x] = rosc_delay
        temp_graph[61-x][60] = rosc_delay
        temp_graph[2][2+x] = 0
        temp_graph[61-x][61] = 0
        temp_graph[1][2+x] = 0
        temp_graph[61-x][62] = 0
        temp_graph[0][2+x] = 0
        temp_graph[61-x][63] = 0
        
    elif(rosc_delay > 7 and rosc_delay <15):
        temp_graph[3][2+x] = 7
        temp_graph[61-x][60] = 7
        temp_graph[2][2+x] = rosc_delay - 7
        temp_graph[61-x][61] = rosc_delay - 7
        temp_graph[1][2+x] = 0
        temp_graph[61-x][62] = 0
        temp_graph[0][2+x] = 0
        temp_graph[61-x][63] = 0
    elif(rosc_delay > 14 and rosc_delay <22):
        temp_graph[3][2+x] = 7
        temp_graph[61-x][60] = 7
        temp_graph[2][2+x] = 7
        temp_graph[61-x][61] = 7
        temp_graph[1][2+x] = rosc_delay - 14
        temp_graph[61-x][62] = rosc_delay - 14
        temp_graph[0][2+x] = 0
        temp_graph[61-x][63] = 0
    else:
        temp_graph[3][2+x] = 7
        temp_graph[61-x][60] = 7
        temp_graph[2][2+x] = 7
        temp_graph[61-x][61] = 7
        temp_graph[1][2+x] = 7
        temp_graph[61-x][62] = 7
        temp_graph[0][2+x] = rosc_delay - 21
        temp_graph[61-x][63] = rosc_delay - 21
        
    return temp_graph

#------------------ Execute Code -----------------#

#scanchaintest(all_row_hi, scanout_clk, scanout_dout64_chip1, scanout_dout64_chip2)

GPIO.output(weight_en, GPIO.HIGH)
GPIO.output(rosc_en, GPIO.HIGH)


#initialize the graph arrays
input_graph_array_chip1 = np.zeros((64,64), dtype=np.int8)
input_graph_array_chip2 = np.zeros((64,64), dtype=np.int8)

adjusted_graph_array_chip1 = np.zeros((64,64), dtype=np.int8)
adjusted_graph_array_chip2 = np.zeros((64,64), dtype=np.int8)


#import the text.txt file
input_graph_array_chip1 = import_graph(input_graph_array_chip1, 'test.txt')
input_graph_array_chip2 = import_graph(input_graph_array_chip2, 'test.txt')

#add manual calibration file to imported test file
input_graph_array_chip1 = add_calibrated_cells(input_graph_array_chip1)

#automatically calibrate the chip
#brute_automation(input_graph_array_chip1,25)

#import the automated calibration generated by brute_automation
#input_graph_array_chip1 = np.copy(apply_calibration(input_graph_array_chip1))

#format the imported graph into a data stream 
adjusted_graph_array_chip1 = modify_array_for_pins(input_graph_array_chip1, adjusted_graph_array_chip1, 59)
adjusted_graph_array_chip2 = modify_array_for_pins(input_graph_array_chip2, adjusted_graph_array_chip2, 59)

#program the chip
program_chip(adjusted_graph_array_chip1, addr_en64_chip1)
program_chip(adjusted_graph_array_chip2, addr_en64_chip2)

#sample the chip
sample_store('chip1_test.txt', 'chip2_test.txt', 100)



GPIO.cleanup()