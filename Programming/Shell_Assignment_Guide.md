# Discussion on the Shell Assignment
We are going to explain the solution to the assignment on shell so every part of the script is well understood.

## Understanding the script:
We know shell is the language the user can use to comunicate with the terminal. Also there is a chance of creating text scripts saved in files `.sh` that admit an execution from the terminal and are read exactly as if we, users, were writing and executing line per line in the machine we want (Python e.g.); also there are some features as functions or loops just like in any other script-based computer language.

To execute a bash file we just need to write in the terminal the following:

        chmod +x file.sh
        bash file.sh
Where the `chmod` turns the file into an executable and `+x` is an option to give certain permissions (we will see it more deeply later).

### Header: shebang and functions
Just like any other script, the header is an important part that may contain functions and some other options.

- *Shebang*: it is a way to tell the machine reading of the script how to run it. In this case, the `/bin/bash` options tell the interpreter to load lines as code input in the terminal.

        #!/bin/bash
- *Functions*: the format of the functions is similar to any other language. In this case, the variables introduced in the function are called `$1`, `$2`... in order of appeareance. This particular functions also take profit on **pipes**, a way to use *standard output* (the text output from the terminal) as *standard input* (the text that serves as an argument) of the next bash function. In this case we are using `grep` and `cut` to select from text certain words. You can see the cheatsheet for more information: https://github.com/jesusff/introduccion-shell/blob/6a1abeadc2897b4668fd1077fc2d05be90ac8919/cheatsheet/bashshell_cs.pdf

        function get_number(){
          grep number $1 | cut -d '>' -f 2 | cut -d '<' -f 1
        }

        function get_name(){
          grep name $1 | cut -d '"' -f 2
        }

- This part is used only to clean the folders before downloading them again.

      rm -r shell-lesson-data
      rm shell-lesson-data.zip

### 1. Download the file https://raw.githubusercontent.com/swcarpentry/shell-novice/f32646f/data/shell-lesson-data.zip
This command, as said in the cheatsheet, is used for dowloading from an url:

    wget https://raw.githubusercontent.com/swcarpentry/shell-novice/f32646f/data/shell-lesson-data.zip

### 2. Unzip it
The name explains it all. Extracts the folder into the current directory.

    unzip shell-lesson-data.zip

### 3. Read the .xml files in folder data/elements and copy them in another (new) folder named elements_by_atomic_number & 4. The file names in this folder should follow the pattern e.g. 008_Oxigen.xml.
We create the directory:

    mkdir -p shell-lesson-data/data/elements_by_atomic_number
We copy the elements to the directory where we are going to work with them. **Remember using the `-R` option to copy directories!**

    cp -R shell-lesson-data/data/elements shell-lesson-data/data/elements_by_atomic_number
We enter the new directory:

    cd shell-lesson-data/data/elements_by_atomic_number
And we execute the loop, combined with the *if*, that allows changing the names of the files. Some things here:
- Notice how is the opening line: it says the kind of files we want to take from the folder.
- Also, we had to use the `$(())` to get the machine consider the variable *number* an integer; in other case the logic condition will not be well understood.
- The conditions are used to get the *00x*, *0xy* and *xyz* numeration: it read the number of digits and writes the necessary zeroes.
- Last, it is remarkable that the `mv` function needs in the destiny file the path indicator: since we are entering the directory in the head of the loop to search for the files, we need to move them also to that place.

Everything together would look like:

    for file in elements/*.xml
    do
      number=$(get_number ${file})
      name=$(get_name ${file})
      ticket=$((number))
      if [ $((number)) -lt 10 ]
      then
        mv ${file} elements/00${number}_${name}.xml
      elif [ $((number)) -lt 100 ] && [ $((number)) -gt 10 ] || [ $((number)) -eq 10 ] 
      then
        mv ${file} elements/0${number}_${name}.xml
      else
        mv ${file} elements/${number}_${name}.xml
      fi
    done

### 5. Change file permissions to be writable by the group and have no read/write permissions for other users.
We use again the `chmod`, in this case with the option `-R` to work with directories, and with a universal key for permissions that you can consult here: https://kb.iu.edu/d/abdb. We are agreeing *to grant read, write, and execute permissions to yourself (4+2+1=7), read and execute permissions to users in your group (4+0+1=5), and only execute permission to others (0+0+1)=1*.

        sudo chmod -R 751 elements

### 6. Create a tar.gz file with these new files, removing all intermediate files and folders created.
*Tar* is a program to compress files or directories in files with the extension `.tar`. To uncompress we would use `tar -x -f elements.tar.gz`. In the script we just compress the directory, move it and erase all intermediate folders created.

    tar -czvf elements.tar.gz elements
    cp elements.tar.gz /home/cayesoneira/Notebooks/shell

    cd /home/cayesoneira/Notebooks/shell
    rm -r shell-lesson-data
    rm shell-lesson-data.zip
