# opencarp_worker
remote worker library that uses opencarp

#copied from caroline's email:
Hi Timothy, 

It was great to meet you on Monday and will be excellent to work together on this project. 

I've uploaded an example to dropbox. 
It is the 
Dropbox link to LA epicardial mesh for case 1 with pacing from the coronary sinus:
https://pubmed.ncbi.nlm.nih.gov/32458222/

https://www.dropbox.com/s/ic3a71s3ryxmgxg/Epi_1.zip?dl=0

The folder contains: 
Labelled_1_1.pts - the points, or nodes, (x, y, z)
Labelled_1_1.elem - the triangular elements, indexed from 0
Labelled_1_1.lon - the fibre file, 1 fibre per element 
Stim_CS.vtx - a list of node indexes that are used to apply a stimulus. The file starts with the number of node indexes it contains. 
CS_1_1.par - a parameter file for 5 beats of pacing the coronary sinus at 700ms cycle length (interval)
act_cs_1_1.par - a parameter file for 1 beat of pacing the coronary sinus where we also calculate an activation map 
CS_1_1 folder - results for CS_1_1.par
act_cs_1_1 folder - results for act_cs_1_1.par
For each of the par files, you have 
simID - where to save your results (should be a sub folder of where this par file is) 
vofile - name used for .igb results file 
dt - time step 
tend - end time for the simulation (in ms) 
num_tsav - how many states to save. You can restart simulations from saved states 
tsav[0] - the time you want to save the first state at (if you increased the number of saved states, you would need to list all of the times to save them at tsav[1] ... tsav[n-1])
write_statef - where to write your state to 
start_statef - if you are starting from a previously saved state, you need to include the file name here. You'll see in act_.par we start from a state that was saved in the previous simulation CS_.par


Ionic model parameters 
num_imp_regions - how many cell types you have 
imp_region[0].im - cell model name (for the first region, here we only have one region) 
imp_region[0].im_param - any changes we want to make to the cell model parameters from the default opencarp values. 

You might need to change JB_COURTEMANCHE to COURTEMANCHE. 

Conductivity parameters 
num_gregions - how many conductivity regions you have (these are defined using labels in the .elem file, we can go through this) 
gregion[0].g_il - longitudinal conductivity  (mS)
gregion[0].g_it - transverse conductivity 

Stimulus parameters 
num_stim - how many different stimuli you define 
stimulus[0].start - when stimulus should start (ms)
stimulus[0].bcl - the pacing cycle length (interval between stimuli)
stimulus[0].vtx_file - where vertex file is that contains node indexes for applying the stimulus

timedt - how often to write a line to the terminal to tell you how far through simulation you are 
spacedt - how often to record the voltage solution (so in CS_.par we only write the solution every 50ms as I didn't post-process this file and wanted to keep the output small, but in act_cs.par we write the solution every 1ms)

meshname - where the mesh is 

num_LATs = 1 - output a file of activation times 

The .igb is the transmembrane voltage over time for each node, you can load it on the mesh using meshalyzer software. The init_acts_vm_act-thresh.dat is the activation times, one per node, you can load using meshalyzer. 

Let me know any questions and if you want a call to go through this 🙂 

Thanks, 
Caroline 


#TODO: verify the brainwarmer task
load caroline's data using meshalyzer

scp TimtheTyrant@login05.osgconnect.net:python3.7-osg.tar.gz python3.7-osg.tar.gz
