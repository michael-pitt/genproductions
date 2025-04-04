import fileinput
import sys 
import os
import shutil
from WprimeWidth import *

#### Set mass ranges to produce ####
masses = [400, 600, 1000, 1600, 2000, 2600, 3000, 3600, 4000, 4600, 5000, 5600, 6000, 6600]

#### Set couplings to produce ####
kR = [0.01, 0.1, 1.0, 2.0, 3.0, 5.0]

#### Set dir with template cards to adjust ####
template_dir = "WprimetoENu_Par-kR-0p01-M-1000_NNPDF31nnlo/"
#### Loop through all masses ####
for mass in masses:
#### Loop through all couplings ####
    for coupling in kR: 
        print(WprimeWidth(mass,coupling))
        directory = ("WprimetoENu_Par-kR-"+str(coupling)+"-M-"+str(mass)+"_NNPDF31nnlo").replace(".","p") # Set the output name
        if os.path.exists(directory): 
			continue
        os.makedirs(directory)        # Create the output directory
        with open(directory+"/"+directory+"_customizecards.dat", "w") as new_cust_file: # Create the output customizecards file
            with open(template_dir+ 'WprimetoENu_Par-kR-0p01-M-1000_NNPDF31nnlo_customizecards.dat', 'r') as f_cust: # Read in the template file 
                for line in f_cust:   # Write the lines and replace the template values with the coupling, mass and width 
                    if 'set param_card kR' in line:
                        new_cust_file.write(line.replace(line.split()[3], str(coupling) + '\n'))
                    if 'set param_card mass 34' in line:
                        new_cust_file.write(line.replace(line.split()[4], str(mass) + '\n'))
                    if 'set param_card DECAY 34' in line:
                        new_cust_file.write(line.replace(line.split()[4], str(WprimeWidth(mass,coupling)) + '\n'))
        with open(directory+"/"+directory+"_proc_card.dat", "w") as new_proc_file:  # Create the output proc card file
            with open(template_dir+'WprimetoENu_Par-kR-0p01-M-1000_NNPDF31nnlo_proc_card.dat', 'r') as f_proc: # Read in the template file
                for line in f_proc:
                    if not 'output' in line: # Only the output line needs adjustment
                        new_proc_file.write(line)
                    if 'output' in line: 
                        new_proc_file.write(line.replace(line.split()[1], directory)) # Replace the output line with the new output name
### Copy the run card an the extramodels and adjust the filename as they do not need any changes                        
        shutil.copy(template_dir + 'WprimetoENu_Par-kR-0p01-M-1000_NNPDF31nnlo_run_card.dat',directory + '/' + directory + '_run_card.dat')
        shutil.copy(template_dir + 'WprimetoENu_Par-kR-0p01-M-1000_NNPDF31nnlo_extramodels.dat',directory + '/' + directory + '_extramodels.dat')
