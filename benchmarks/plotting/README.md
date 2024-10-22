## plotting

If you use Nix, you can enter the developement environment:
```bash
nix develop
```

Create a virtual python environment:
```bash
python3 -m venv .venv
```

Enter the python edevelopement environment
```bash
source .venv/bin/activate
```

Create a kernel for jupyter:
```bash
python -m ipykernel install --user --name=venv
```

Install the requirements:
```bash
pip install -r requirements.txt
```

Run jupyter notebook:
```bash
jupyter lab
```
