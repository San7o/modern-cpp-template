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

Install the requirements:
```bash
pip install -r requirements.txt
```

Run jupyter notebook:
```bash
python3 -m jupyter lab
```

## read system data

Read memory speed:
```bash
sudo dmidecode --type 17 | grep "Memory Speed"
```

## TODO
Use seaborn
