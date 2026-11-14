# Protocolo del TFM

**Título provisional:** Evaluación experimental de arquitecturas RAG para preguntas y respuestas sobre documentación en ética y regulación de la IA

**Autores:** Estudiante A (recuperación) · Estudiante B (generación y evaluación)
**Tutor:** _por completar_
**Versión / fecha:** v0.1 · _por completar_

> Regla: hipótesis y métricas se fijan **antes** de ver resultados. Todo cambio posterior se registra en la sección 11 con su justificación.

---

## 1. Contexto y brecha
- Motivación: los LLM pueden responder con información incorrecta, desactualizada o sin fuente verificable; RAG mitiga esto sin reentrenar.
- Brecha: se sabe montar un RAG, pero hay poca evidencia sistemática de **qué decisiones de diseño importan y cuánto**, sobre normativa en español.
- _Completar tras la revisión de literatura (semana 4)_: qué se sabe, qué no, qué aporta este trabajo.

## 2. Pregunta de investigación
¿Cuánto del desempeño, la fidelidad, la latencia y el costo de un sistema RAG sobre documentación normativa y ética en español se explica por la segmentación, la representación semántica, la recuperación y la generación, y cómo se comparan esas conclusiones con las de un benchmark público de documentación técnica?

## 3. Hipótesis
| ID | Hipótesis |
|----|-----------|
| H1 | Recall@k explica la mayor parte de la varianza de la corrección, pero la fidelidad depende más del generador y de k. |
| H2 | En texto normativo, el chunking por estructura (artículo/sección) supera al de tamaño fijo; el semántico no compensa su costo. |
| H3 | Híbrido + reranker lidera en calidad, pero queda dominado en el frente de Pareto bajo un presupuesto de latencia. |
| H4 | Aumentar k mejora el recall pero degrada la fidelidad a partir de cierto punto (*lost in the middle*). |
| H5 | El ranking de configuraciones cambia entre el benchmark público y el corpus en español. |
| H6 | Ante preguntas con conflicto entre conocimiento previo y documento, un mejor recuperador reduce respuestas basadas en información obsoleta. |

## 4. Corpus
- 6–10 documentos públicos y oficiales (AI Act consolidado en español, UNESCO 2021, OCDE, NIST AI RMF + perfil GenAI, 2–3 documentos latinoamericanos, opcional Consejo de Europa).
- Registro en `data/corpus_manifest.csv`: fuente oficial, licencia, URL, fecha de descarga, versión.
- **Congelación:** fecha de la «foto» del corpus: _por completar_. No cambiar durante los experimentos.
- Extracción (HTML preferente; PDF con PyMuPDF/pdfplumber) y **medición de calidad de extracción** (tablas, encabezados, notas al pie, numeración).
- Estructura conservada: documento → capítulo → artículo → sección.

## 5. Banco de preguntas (200–300)
| Tipo | Qué mide |
|------|----------|
| Dato puntual | Recuperación básica |
| Varios pasajes del mismo documento | Cobertura y completitud |
| Comparación entre documentos | Recuperación multi-documento |
| Conflicto con conocimiento previo | Fidelidad frente a memoria |
| Sin respuesta en el corpus | Abstención y alucinación |

Proceso: candidatas con ayuda de LLM → validación manual → respuesta de referencia corta → doble anotación ≥20 % (kappa de Cohen) → exclusión de preguntas interpretativas/generales → separación desarrollo/prueba (prueba intocable hasta el final).

## 6. Benchmark de contraste y controles
- **RAGBench** (EManual, TechQA, DelucionQA): reconstruir corpus por subconjunto y definir evidencia.
- **Controles obligatorios:** (a) sin recuperación; (b) recuperación oráculo; (c) preguntas sin respuesta.
- Referencias/controles opcionales: AI Act Evaluation Benchmark (revisar antes de usar), MIRACL-es, MessIRve, RagQuAS.

## 7. Factores experimentales
| Factor | Niveles |
|--------|---------|
| Chunking | Tamaño fijo (256/512/1024, solape 0 y 10–20 %), recursivo, por estructura, semántico |
| Embeddings | 3–4 modelos (incl. multilingüe tipo BGE-M3 y uno en inglés) |
| Recuperación | BM25, densa, híbrida (RRF), + reranker (cross-encoder) |
| k | 3, 5, 10 |
| Generador | 2 LLM abiertos cuantizados, temperatura 0, semillas fijas |
| Prompt | Base; citar fuentes y abstenerse |
| Orden del contexto | Por ranking / invertido / aleatorio (H4) |

## 8. Métricas
| Dimensión | Métricas |
|-----------|----------|
| Recuperación | Recall@k, MRR@10, nDCG@10, acierto por documento y artículo |
| Corrección | EM/F1 (respuestas cortas); juez LLM o semántica (largas) |
| Fidelidad | Adherencia (TRACe), precisión/recall de afirmaciones (RAGChecker), RAGAS |
| Atribución | Exactitud a nivel de artículo/sección |
| Abstención | Tasa de abstención correcta y de alucinación en preguntas sin respuesta |
| Eficiencia | Latencia p50/p95 por etapa, memoria, tokens, tiempo de indexación |

**Definición de resultado válido (ejemplo):** «Recall@k calculado sobre las preguntas con evidencia, a nivel de artículo».

## 9. Diseño estadístico
- Intervalos de confianza por bootstrap sobre preguntas; pruebas pareadas.
- Descomposición de varianza (ANOVA o modelos mixtos) con interacciones.
- Frente de Pareto calidad–latencia–costo.
- Repeticiones para medir variabilidad.
- Juez LLM **distinto** del generador; validación humana de ~100 respuestas (kappa).

## 10. Criterios de exclusión y reproducibilidad
- Excluir/marcar preguntas ambiguas o interpretativas; sin preguntas generales respondibles de memoria.
- Un archivo de configuración por experimento (`configs/`), semillas fijas, índices y embeddings en caché.
- Registrar por pregunta: fragmentos recuperados con puntajes, respuesta, tiempos y tokens.
- Dependencias con versiones fijadas (`requirements-lock.txt`); seguimiento con MLflow/W&B.
- Uso responsable: el sistema **no es asesoría legal**; incluir advertencia y discutir límites.

## 11. Plan, roles y registro de cambios
**Roles:** A: chunking, embeddings, BM25/densa/híbrida, reranker, métricas de recuperación. B: LLM, prompts, fidelidad, abstención, validación humana, costo y latencia. Compartido: corpus, banco de preguntas, infraestructura, varianza, discusión.

**Reglas:** un repositorio, ramas por línea, *pull requests* revisados; nadie fusiona sin revisión cruzada; avisar al tutor durante la semana si hay retraso.

| Semanas | Fase | Entregable |
|---------|------|------------|
| 1–2 | Protocolo y organización | Protocolo de 4 páginas |
| 1–4 | Revisión de literatura | Matriz de artículos |
| 2–6 | Datos | Corpus, preguntas, evidencia y kappa |
| 5–8 | Recuperación sin LLM | Grilla de métricas de recuperación |
| 8–12 | Generación | Corrección y fidelidad |
| 10–14 | Evaluación y análisis | Tablas, intervalos, frente de Pareto |
| 13–15 | Ablaciones, errores y réplica | Taxonomía de fallos |
| 15–18 | Redacción y defensa | Memoria y código |

Hitos con el tutor: semana 4, semana 8, semana 14.

**Registro de cambios respecto al protocolo**
| Fecha | Cambio | Justificación |
|-------|--------|---------------|
| | | |
