import subprocess
import os

CODE_PATH = "/opt/AvantData/volumes/avantdata/codigo"
BUNDLE = "/tmp/avantdata.bundle"
COMMIT_NAME = "Update AvantData"

def run_command(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()

    if process.returncode != 0:
        print(f"Error occurred: {error}")
        return False

    return True

def main():
    gitignore_content = """
# Ignore vendor directory (for Composer dependencies)
/vendor/

# Ignore any files or directories within the "public" directory that is typically used for serving the application
/public/

# Ignore logs and cache directories
/logs/
/cache/

# Ignore any configuration files that may contain sensitive information
/config/*.php

# Ignore any generated files or directories
/generated/

# Ignore any backup files
*.bak
*.swp
*~

# Ignore any files or directories that are specific to your development environment
.env
.env.*

# Ignore any build or compiled files
/build/
/dist/
*.exe
*.dll

# Ignore any database files
*.sql
*.sqlite

# AvantData
AvantdataNovo/users/*
AvantdataNovo/app/models/python/ra2d/temp/*
AvantdataNovo/app/models/arquivos/*
TWI/AvantIntel/modelos/*
config/EntradaDeDados/EntradaDeArquivos/uploads/*
AvantdataNovo/app/views/inicial/img/*
AvantFlow/attachments/*
scripts/config/*

nbproject/
# Vs Code
.vscode

# Gitignore antigo
/Carrapato/Mobile/APKs
/Carrapato/Satelital
/Carrapato/AvantVoip/tmp
/Carrapato/carrapatoMobile/MidiaADTrack
/img
/.scannerwork/
/atualizacao/versao/configuracao.json
/AvantFlow/json
/atualizacao/latest/
/scripts/alertas/resultados/*txt
/scripts/alertas/scriptsUploads/*sh
/config/EntradaDeDados/EntradaDeArquivos/uploads/*csv
/.idea/
/.jshintrc
/AvantdataNovo/.idea/
/AvantdataNovo/venv/
/venv/
.vscode/settings.json
AvantdataNovo/teste
/**/composer.lock
/AvantIntel/modelos/*.sav
*.pyc
__pycache__
/AvantdataNovo/app/models/arquivos/ra2d/
/AvantdataNovo/vendor/
node_modules
/AvantdataNovo/users/pcap/
/TWI/AvantIntel/NLP/modelos/*.sav
/AvantdataNovo/app/models/python/ra2d/temp/*.json
/AvantdataNovo/public/js/src
/AvantdataNovo/composer.lock
composer.lock

# Versões Antigas do AvantAgent
AvantAgent\Old

# Sonar Qube
.scannerwork

#configuração do javascript
jsconfig.json

# Ignore all __pycache__ and *.pyc
/**/__pycache__/*
/**/*.pyc

# Slim
/.phpdoc/
/nbproject/private/
/config/

# PythonIntegration
__pycache__/
*.sh

"""

    os.chdir(CODE_PATH)

    with open(".gitignore", "w") as f:
        f.write(gitignore_content)

    commands = [
        "git init",
        "git add .",
        f"""git -c user.email="suporte@avantdata.com.br" -c user.name="avantdata" commit -m '{COMMIT_NAME}'""",
        f"rm -rf {BUNDLE}",
        f"git bundle create {BUNDLE} HEAD"
    ]

    for command in commands:
        if not run_command(command):
            print(f"Command failed: {command}")
            break

if __name__ == "__main__":
    main()
