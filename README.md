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
4. `LaTeX` -> `LaTeX + RCJ formatting` (_to ensure uniformity of the output_)
5. `LaTeX + RCJ formatting` -> **PDF**

At the end of this process we end up with a **HTML** and a **PDF** version of
the AsciiDoc file we started with.

This repository is connected to so called [Travis CI](http://travis-ci.org/)
which allows us to automatically build the rules whenever any change/update
takes place.

If you'd like to build the rules on your own computer you have to follow the instructions below.

## Use GitHub Codespaces to edit and build these files

GitHub now has a nice service called [Codespaces](https://github.com/features/codespaces) which allows us to spin up a "development environment" without having to install various dependencies without having to leave the web browser.

### Building rules in Codespaces

1. First, navigate to the top part of the repository.

2. Click on **Code** and then on **Create codespace on 2026-draft**

3. You should now be able to navigate the rule files in the various directories (`onstage_rules/rules.adoc`, `onstage_entry_rules/rules.adoc`) and edit them as you like.

4. To actually build rules as a PDF and/or HTML, you can execute the following:

        bash scripts/build-rules.bash onstage_rules

   Or for entry rules:

        bash scripts/build-rules.bash onstage_entry_rules

5. After the script has run, you will see the final output files created in the rules_documents directory (e.g., `onstage_rules.html` and `onstage_rules.pdf`).

6. To serve the files in a browser, you can run:

        python -m http.server 12345

   Then access the files at `http://localhost:12345/rules_documents/onstage_rules.html` and similar URLs.

### Linux or MacOS System

1. Install [Docker](https://docker.com) with the instructions on the website.
2. Open a console and run the following commands
3. `docker run -v $(pwd):/documents asciidoctor/docker-asciidoctor .ci/adoc-to-tex.sh <FOLDER>`
4. `docker run -v $(pwd):/documents mrshu/texlive-dblatex .ci/tex-to-pdf.sh <FOLDER>`

These commands will make the `rules.adoc` file (in the current working directory --
that's the `$(pwd)` part) go through the build steps above and generate the files
`rules.html` and `rules.pdf` as a result.

### Windows System

When running on Windows you initially have to do a few extra extra steps to be able to build 
the rules using the Linux scripts with the windows subsystem for Linux.   

1. Install the [Windows subsystem for linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install)
2. Open the WSL (search for WSL in the Windows search bar) and create username and passwort
5. Install [Docker](https://docker.com) with the instructions on the website if not done yet
6. Run the [build_rules_on_windows script](https://github.com/robocup-junior/onstage-rules/blob/main/build_rules_on_windows.bat) to build the rules

It helps to have a wsl console runing in the background all the time to avaoid windows starting and stopping it everytime the script is run, as this takes up some time. Just type wsl in the windows search bar to open it.

You can now find the PDF and HTML version of the rules in the rules_documents folder.
