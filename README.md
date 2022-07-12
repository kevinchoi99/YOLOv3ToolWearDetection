# YOLOv3ToolWearDetection
An AI Machine Vision Tool Wear Detection System utilising YOLOv3 AI object detection with SqueezeNet Architecture

# Introduction
In this project, an Artificial Intelligent (AI) Machine Vision (MV) system in the MATLAB environment was developed for in-process Tool Condition Monitoring (TCM) to detect the location and type of wear present on the tool insert based on ISO 8688-1 standard.By applying AI and MV, the human intervention aspect of traditional TCM, which involves manual removal of the tools for inspections under a microscope, can be removed to acquire the tool wear progression directly in the machine itself between runs (in-process) and detect the type of wear the tool is experiencing. The MV-TCM was applied firstly by constructing the camera setup within a CNC machine environment, which acquires the images of the tool inserts between machining runs and uploads them into a connected computer. A simple binary classifier (ResNet) was trained to identify ideal tool insert images from unwanted (non-tool insert) residue images. The camera input images are run through the binary classifier to obtain the tool inserts present on the cutting tool, which are then used as the input for the detection network. With literature attributing YOLOv3 as the main deep learning architecture, it was used as the detection network in the present study to locate and classify the type of wear present on the tool’s cutting edge. The detection network was trained with 1068 images to learn different types of failure modes (Uniform Flank Wear, Chipping, Notching, Flaking and Built-Up-Edge). 

# Downloading and Setting up
1.  Download all the files in the repository 
2.  Make sure the latest version of MATLAB is downloaded and installed
3.  Install the following packages/add ons in MATLAB:
    1.  Image Labeller App
    2.  Deep Learning Toolbox
    3.  Statistics and Machine Learning Toolbox
    4.  Computer Vision Toolbox
    5.  Image Processing Toolbox
    6.  Parallel Computing Toolbox
4.  Open the file 'tool_wear_prediction'
5.  Change the 'image_folder' variable to the destination of the images that is to be detected
6.  Run the program
    

