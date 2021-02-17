#! /bin/bash

tee -a $HOME/.bashrc << EOF
python3 -m webbrowser http://localhost:8888
EOF