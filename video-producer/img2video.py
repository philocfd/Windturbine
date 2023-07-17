#!/usr/local/bin/python3

from pickletools import optimize
import cv2
import argparse
import os
from PIL import Image
from pathlib import Path


def convert_img2_video(dir_path, ext, output, dur):
    """
    Combine images into video.
    Keyword arguments:
    dir_path -- directory storing the images
    ext -- extentsion of images
    output -- name of the generated video
    dur: duration per frame in ms
    return:
    None
    """
    # image_files = dir_path.glob("*.PNG")
    # print(list(image_files))
    fps = int(1000/dur)
    images = []
    for f in os.listdir(dir_path):
        if f.endswith(ext):
            images.append(f)
    # Determine the width and height from the first image
    image_path = os.path.join(dir_path, images[0])
    frame = cv2.imread(image_path)
    cv2.imshow('video', frame)
    height, width, channels = frame.shape

    # Define the codec and create VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # Be sure to use lower case
    out = cv2.VideoWriter(dir_path + os.sep + output,
                          fourcc, fps, (width, height))

    for image in images:

        image_path = os.path.join(dir_path, image)
        frame = cv2.imread(image_path)

        out.write(frame)  # Write out frame to video

        cv2.imshow('video', frame)
        if (cv2.waitKey(1) & 0xFF) == ord('q'):  # Hit `q` to exit
            break

    # Release everything if job is finished
    out.release()
    cv2.destroyAllWindows()

    print("The output video is {}".format(output))


def combine_img2_gif(workdir, ext, output_name, dur):
    """
    Combine images into gif.
    Keyword arguments:
    """
    images = []
    for f in os.listdir(workdir):
        print(f)
        if f.endswith(ext):
            images.append(Image.open(os.path.join(dir_path, f)))
    images[0].save(workdir + os.sep + output_name, save_all=True,
                   append_images=images, optimize=False, duration=dur,
                   loop=0)


if __name__ == "__main__":
    # How to use
    # python img2video.py  -p "D:\Work\2023\zhouGiantRotor\pitchL35\Q" -d 400 -ext png -o q.gif
    # Construct the argument parser and parse the arguments
    ap = argparse.ArgumentParser()
    ap.add_argument("-ext", "--extension", required=False,
                    default='png', help="extension name. default is 'png'.")
    ap.add_argument("-o", "--output", required=False,
                    default='output.mp4', help="output video file")
    ap.add_argument("-d", "--duration", required=False,
                    default=400, help="duration per frame in ms")
    ap.add_argument("-p", "--dirpath", required=False,
                    default='D:\Work\2023\floater_aero', help="Working path")
    args = vars(ap.parse_args())
    # Arguments
    # dir_path = r'D:\Work\2023\floater_aero'
    ext = args['extension']
    output = args['output']
    dur = int(args["duration"])
    dir_path = args["dirpath"]
    if output.endswith(".mp4"):
        convert_img2_video(dir_path, ext, output, dur)
    elif output.endswith(".gif"):
        combine_img2_gif(dir_path, ext, output, dur)
    else:
        print("The code cann't produce video of {} format".format(
            output.split(".")[-1]))
        exit
