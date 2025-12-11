![CI Pipeline](https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/ci-pipeline.yml/badge.svg)
![CI (alternate)](https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/ci.yml/badge.svg)
![Docker Action](https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/docker-container-action.yml/badge.svg)
![Multi-OS Test](https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/multi-os-test.yml/badge.svg)
![System Automation](https://github.com/AbrahamRP97/so-github-actions-labs/actions/workflows/system-automation.yml/badge.svg)


Workflows (explicación rápida)
	* CI Pipeline (ci-pipeline.yml): Ejecuta tests y genera cobertura en Ubuntu, Windows y macOS; sube artifacts de coverage.
	* CI (ci.yml): Workflow alterno/auxiliar para pruebas rápidas o branch-specific.
	* Docker Action (docker-container-action.yml): Construye la imagen Docker definida en Dockerfile, ejecuta contenedor y monitorea recursos.
	* Multi-OS Test (multi-os-test.yml): Recolecta info del sistema en runners ubuntu/windows/macos y sube artifacts con los logs.
	* System Automation (system-automation.yml): Ejecuta scripts de automatización (chmod/icacls, background processes, manejo de archivos) y genera artifacts.
