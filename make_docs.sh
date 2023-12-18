#!/bin/bash

#This scripts turns a repo into sphinx documentation and uploads to github pages

#Required:
#	apt install python3-sphinx
#	pip3 install sphinx-argparse
#	pip3 install sphinx-design
#	pip3 install sphinx-rtd-theme


#vars
AUTHOR='D-Tacq'
PROJECT='acq400_hapi'
RELEASE='2.10.0'
LANG='en'
REPO='https://github.com/D-TACQ/acq400_hapi'

#REPO='https://github.com/D-TACQ/acq400_hapi -b doc' #until big merge

#REPO='https://github.com/sambelltacq/acq400_hapi -b SPHINX_CLEANUP' #for testing

#display
YELLOW="\033[0;33m"
RESET="\033[0m"
set -e


#ENV setup
export PYTHONPATH=$PYTHONPATH:$(dirname $(realpath "${BASH_SOURCE[0]}" ))/acq400_hapi
export PROJECT_DIR=$(realpath $PROJECT )
echo $PYTHONPATH
echo $PROJECT_DIR

#path setup
html_dir="docs" #github pages requirement
sphinx_root="sources"
sphinx_src="$sphinx_root/source"
custom_dir="custom"
template_dir="$custom_dir/templates"


#remove stale
rm $html_dir -rf
rm $sphinx_root -rf

git clone $REPO $PROJECT || true
RELEASE=$(cd $PROJECT;git log -n 1 --pretty=format:"%H")


#sphinx-quickstart generates conf.py, index.rst, source dir
export LC_ALL=C #??? needed to stop locale error
echo -e "$YELLOW sphinx-quickstart --no-batchfile  --sep -p $PROJECT -a $AUTHOR -r $RELEASE -l $LANG -t $template_dir $sphinx_root $RESET"
sphinx-quickstart --no-batchfile  --sep -p $PROJECT -a $AUTHOR -r $RELEASE -l $LANG -t $template_dir $sphinx_root

#add custom files into source dir
cp $custom_dir/static/custom_style.css $sphinx_src/_static/
cp $custom_dir/static/d-tacq_logo.svg $sphinx_src
cp $custom_dir/static/d-tacq_logo.ico $sphinx_src


#sphinx-apidoc merely generates “stubs” for each module
# The stubs contain automodule directives which in turn inform sphinx-build to 
#invoke autodoc to do the heavy lifting of actually generating the API documentation 
echo -e "$YELLOW python3 custom/apidoc.py $PROJECT -o $sphinx_src -M -e -d 1 -t $template_dir -PR $RESET"
python3 custom/apidoc.py $PROJECT -o $sphinx_src -M -e -d 1 -t $template_dir -PR
sed -i '1,2d' $sphinx_src/modules.rst #trim title from toc


#build all the source files into html
echo -e "$YELLOW sphinx-build $sphinx_src $html_dir $RESET"
sphinx-build $sphinx_src $html_dir
> $html_dir/.nojekyll #needed for github pages


#cleanup, comment out for debugging
rm $sphinx_root -rf
rm $PROJECT_DIR -rf

#update git
echo To see results open "$PWD/docs/index.html" in browser
echo 'To commit changes do:'
echo git add $html_dir
echo git commit -m \"Updated to commit $RELEASE\"
echo git push



