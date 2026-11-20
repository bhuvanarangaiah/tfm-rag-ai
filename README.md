# tfm-rag-ai

Evaluación experimental de arquitecturas RAG para preguntas y respuestas sobre documentación en ética y regulación de la IA (corpus en español + contraste con RAGBench).

## Estructura
```
data/raw/            documentos originales (no se versionan)
data/processed/      texto extraído y chunks (no se versionan)
data/corpus_manifest.csv   fuente, licencia, URL, fecha, versión de cada documento
src/                 código (carga, chunking, recuperación, generación, evaluación)
configs/             un YAML por experimento
results/             salidas de experimentos
notebooks/           exploración y análisis
docs/protocolo.md    protocolo del TFM
```

## Entorno
Python **3.12 o 3.13** (3.9 y 3.10 ya están fuera de soporte). Verificado en 3.13.
```bash
bash setup_env.sh            # crea .venv, instala dependencias y genera requirements-lock.txt
source .venv/bin/activate
```
Para Colab (GPU T4): `pip install -r requirements-colab.txt`.

## Flujo de trabajo
- Una rama por línea de trabajo; cambios por *pull request* con revisión cruzada.
- No se suben datos, índices ni credenciales.
- Cada tabla y figura debe poder reproducirse con una config y un comando.

## Estado
- [ ] Fase 1: protocolo y organización
  - [x] Repositorio creado
  - [x] Entorno fijado (Python 3.13, `requirements-lock.txt`)
  - [ ] Protocolo completo (nombres, tutor, versión y fecha)
  - [ ] Hipótesis y métricas congeladas (etiqueta `protocol-v1.0` tras revisión cruzada)
  - [ ] Revisión cruzada y protección de `main` activadas
