![Logo](https://www.d-tacq.com/images/dtacq.png)

D-Tacq [acq400_hapi](https://github.com/D-TACQ/acq400_hapi) documentation

[online docs](https://sambelltacq.github.io/acq400_hapi_docs/)

### Dependencies:

* [Sphinx](https://www.sphinx-doc.org/en/master/usage/installation.html)
* [sphinx-argparse](https://sphinx-argparse.readthedocs.io/en/latest/install.html)
* [sphinx-design](https://sphinx-design.readthedocs.io/en/rtd-theme/)
* [sphinx-rtd-theme](https://sphinx-rtd-theme.readthedocs.io/en/stable/installing.html)

### How To

Install dependencies:
```
    apt install python3-sphinx

    pip3 install sphinx-argparse
    pip3 install sphinx-design
    pip3 install sphinx-rtd-theme
```

Clone and Run:
```
    git clone https://github.com/sambelltacq/acq400_hapi_docs
    cd acq400_hapi_docs
    ./make_docs.sh
```

Push updated docs to master branch

```
    git add docs/
    git commit -m 'made from repo at commit <HASH>'
    git push
```

