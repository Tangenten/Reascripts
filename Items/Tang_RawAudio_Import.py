import sys
sys.argv=["Main"]

from pydub import AudioSegment

import tkinter
from tkinter import *
from tkinter.filedialog import askopenfilename

filename = ""

def selFile():
    global filename
    filename = askopenfilename()

def quit():
  global root
  root.destroy()

def run():
    getChannels = int(channels.get())
    getSampleWidth = int(sampleWidth.get())
    raw_audio = AudioSegment.from_file(filename, format="raw", frame_rate=44100, channels = getChannels, sample_width = getSampleWidth)

    filenameSplit = filename.split("/")

    resourcePath = RPR_GetResourcePath()
    (retval, idx, projfn, projfn_sz) = RPR_EnumProjects(-1, "", 512)
    (projectPath, buf_sz) = RPR_GetProjectPath(retval,512)

    raw_audio.export(projectPath + "/" + filenameSplit[-1] + ".wav", format="wav")
    RPR_InsertMedia(projectPath  + "/" + filenameSplit[-1] + ".wav", 0)
    quit()

root = tkinter.Tk()
root.title('Raw File to Wave Import')
root.resizable(0, 0)
root.minsize(width=300, height=200)

sampleWidth = StringVar(root)
sampleWidth.set(1)

sampleWidthMenu = OptionMenu(root, sampleWidth, 1, 2, 4)
sampleWidthMenu.pack()

channels = StringVar(root)
channels.set(1)

channelsMenu = OptionMenu(root, channels, 1, 2)
channelsMenu.pack()

Button(root, text ="Run", command = run).place(bordermode=INSIDE, height=25, width=60, x=135, y=100)

Button(root, text ="File", command = selFile).place(bordermode=INSIDE, height=25, width=60, x=60, y=100)

root.mainloop()

