# cs4244-08 Laptop Recommendation System

----

# GUI

## Installation

Ensure you have Python 2.7 installed, then run `pip install -r requirements.txt`.
This will install Flask, a simple web framework.

## Running the server

Run `python index.py` and the server should run automatically. Head to
`localhost:5000` on your browser. This should then start an instance of `clips` as a subprocess.

If you do not have `clips` on your command line, follow these steps:

1. Download [https://sourceforge.net/projects/clipsrules/files/CLIPS/6.30/](`clips_mac_osx_executable_630.zip`).
1. Extract, rename `CLIPS Console` to `clips` and place it in a directory that is found in your PATH. (`echo $PATH`)


## Special printouts

The server accepts a string of input, and returns a string of output.
The output to be returned is terminated by special keywords:

- `CLIPS>`: This is part of Clips' printing interface and is detected automatically.
- `</end>`: Use this when you expect user input after your output.


On the client side, the following keywords are parsed and provides different controls:

- `<opt>`: Use this to signal that the user should pick from an option list. Example syntax:
`<opt>1[Full HD] 2[4K] 3[No requirement]</end>`. The number will be input to Clips, while the text
in the brackets will be shown to the user.
- `<bool>`: Use this to signal that the user should pick from Yes/No options. Example syntax:
`<bool></end>`. For "Yes", a value of _y_ will be sent. For "No", a value of _n_ will be sent.

Without the above keywords, the user is expected to input a non-negative integer.


## Debugging

You can also run Clips commands on the debug input found at the bottom of the webpage.
Be careful not to run commands that will print out special keywords mentioned above (e.g. `(facts)`,
as the detection of the terminating keywords will be inaccurate.
