## Building the PDF rules on your own

The rules are written in a format called `asciidoc`. It is very similar to
Markdown but unlike Markdown, it is very extensible and has a nice ecosystems
of tools around it. To get a feel for what it looks like, please take a look at
the [AsciiDoc Writer's Guide](https://asciidoctor.org/docs/asciidoc-writers-guide/).

Despite how great it is, the rules cannot be built with AsciiDoc alone. They
need to be exported into PDF, in a specific format, and we'd also like them to
highlight the changes in a nice way and automatically generate IDs for each
paragraph. To do all this, the input AsciiDoc file goes thorugh the following
steps:

1. `AsciiDoc` -> `CriticMarked AsciiDoc` (_to visualize rule changes in red_)
2. `CriticMarked AsciiDoc` -> **HTML**
3. `CriticMarked AsciiDoc` -> `LaTeX` (for formatting purposes)
4. `LaTeX` -> `LaTeX + RCJ Soccer formatting` (_to ensure uniformity of the output_)
5. `LaTeX + RCJ Soccer formatting` -> **PDF**

At the end of this process we end up with a **HTML** and a **PDF** version of
the AsciiDoc file we started with.

This repository is connected to so called [Travis CI](http://travis-ci.org/)
which allows us to automatically build the rules whenever any change/update
takes place.

If you'd like to build the rules on your own computer you have to follow the instructions below.

### Linux or MacOS System

1. Install [Docker](https://docker.com) with the instructions on the website.
2. Open a console and run the following commands
3. `docker run -v $(pwd):/documents asciidoctor/docker-asciidoctor .ci/adoc-to-tex.sh rules`
4. `docker run -v $(pwd):/documents mrshu/texlive-dblatex .ci/tex-to-pdf.sh rules`

These commands will make the `rules.adoc` file (in the current working directory --
that's the `$(pwd)` part) go through the build steps above and generate the files
`rules.html` and `rules.pdf` as a result.

### Windows System

When running on Windows you initially have to do a few extra extra steps to be able to build 
the rules using the Linux scripts with the windows subsystem for Linux.   

1. Install the [Windows subsystem for linux(WSL)](https://learn.microsoft.com/en-us/windows/wsl/install)
2. Open the WSL (search for WSL in the Windows search bar) and create username and passwort
5. Install [Docker](https://docker.com) with the instructions on the website if not done yet
6. Run the [build_rules_on_windows script](https://github.com/robocup-junior/onstage-rules/blob/main/build_rules_on_windows.bat) to build the rules

You can now find the PDF and HTML version of the rules in the rules_documents folder.
