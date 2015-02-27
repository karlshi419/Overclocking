__author__ = 'Kan Shi'
import fileinput
import os
from os.path import getsize, join, isfile, exists

base_freq = 650

#base_freq = 510
step=10
#base_freq = 200
#step = 20

img='tiffany'
img_def = 1

def file_rename(mmcm_state):
    #print mmcm_state[0]
    global img
    global img_def

    mmcm = int(mmcm_state[0])
    if (mmcm<4):
        freq = 200 + mmcm * 50
    elif (mmcm<9):
        freq = 320 + mmcm * 20
    else:
        freq = 410 + mmcm * 10
    if img_def:
        filename = img+'_data_'+str(freq)+'_MHz'+'.txt'
    else:
        filename = 'uniform_data_'+str(freq)+'_MHz'+'.txt'

    return filename


def file_select(filename):

    fid = fileinput.input(files=(filename))
    fid_out = open('./test.txt','w')    # temperate file, will change later

    std_file_size = 36000   #standard file size, should be 86016

    for line in fid:
        #print(fileinput.lineno())  #line number starts from 1!
        if(fileinput.lineno()==1):
            continue
        elif(fileinput.lineno()==2):
            result = ' '.join(line.split()[2:3]) + '\n'
            mmcm_state = line.split()[3:4]

            filename_out = file_rename(mmcm_state)
            #print filename_out
            if isfile(filename_out):    # file exists
                size = getsize('./'+filename_out)
                #print(size)
                if size < std_file_size:
                    print('Uncomplete data file exits, will be replaced.')
                    fid_out = open(filename_out,'w+')
                    fid_out.write(result)
                else:
                    print('\tGood data file exists, pass.')
                    break
            else:
                print('Create new file: '+filename_out)
                fid_out = open(filename_out,'w')
                fid_out.write(result)
        else:
            result = ' '.join(line.split()[2:3]) + '\n'
            BRAM_read_en = line.split()[4:5] #either ['1'] or ['0']
            #print (BRAM_read_en[0])
            if ('1' in BRAM_read_en):
                fid_out.write(result)


    fid.close()
    fid_out.close()

#    result = [line[6:] for line in open(r'test.1.prn')]
#    open(r'test.txt', 'w').writelines(result)

def file_fetch(path):

    #std_size = 231000

    if not os.path.isdir(path): #check if path is a valid path
        print 'Not a valid path'
        return
    #print path
    for root, dirs, files in os.walk(path):
        for filename in files:
            print 'Found file: '+ filename
            #filesize = getsize(join(root, filename))

            if filename=='sum_EF.txt':
                continue
            else:
                filename_full = path+filename
                file_select(filename_full)

def create_work_dir(path_root):
    # scan the entire matlab directory and create folders
    dir_type = ['data','data_bk']
    input_type=['uniform','lena','pepper','sailboat','tiffany']

    for d in dir_type:
        path=path_root+d+'/'
        if not exists(path):
            print('Directory: '+d+' not exits, will create one.')
            for i in input_type:
                path_dir=path+i+'/'
                os.makedirs(path_dir)
                print('Directory: '+i+' created.')
                if (d=='data_bk'):
                    print('Creating directories for multiple runs.')
                    for run in range(1,4):
                        path_run=path_dir+'run'+str(run)
                        os.mkdir(path_run)
        else:
            print('Directory: '+d+' exits')

def temp_main():
    #filename = '../data/test.1.prn'
    #file_select(filename)
    global img
    global img_def
    path_root = '../'
    create_work_dir(path_root)
    if img_def:
        path = '../data/'+img+'/'
    else:
        path = '../data/uniform/'
    file_fetch(path)


if __name__ == "__main__":
    temp_main()