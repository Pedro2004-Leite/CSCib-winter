# CSCib - Control of Cyber-Physical Systems

IST · DEEC / Sistemas, Decisão e Controlo · 2026/2027, 1º semestre · 6 ECTS

- **Coordenador:** Sérgio Pequito
- **Docente:** José Gaspar
- **Monitora:** Rita Mota

## Datas

- **Relatório:** 23:59 do dia da sessão L12 (semana 14). 7 dezembro (CSCibL02/L03) · 10 dezembro (CSCibL04/L05)
- **Exame:** 15 janeiro 2027, 10:30

## Avaliação

- 5 testes MAP30: **60%** (contam as 3 melhores notas)
- Projeto / laboratório: **40%** (fator de validação coletivo + termo individual)
- Regras completas, mínimos, faltas, épocas de recurso e política de IA: `CCPS_Metodos_de_Avaliacao_2026-27_PT.pdf` / `..._EN.pdf` (Fénix)

## Laboratório

- **Guia:** `Laboratories_Control_of_CPS_semester.pdf` (neste repo)
- 13 sessões de 1h30 (L1-L13), mapeadas para os módulos das aulas
- Parte I - Identificação (Q1, Q2, Q3) · Parte II - Controlo LQG (Q4)
- **Template do relatório:** `Template_report.zip` (neste repo, LaTeX)
- Máx. 15 páginas da Introdução às Conclusões. Capa, índice, declarações e apêndice de código não contam
- Todas as funções criadas vão no apêndice. Declarações de IA e de originalidade são obrigatórias

## Sessões de laboratório

Um link por sessão. Substituir `_` pelo URL do Google Docs.

| Sessão | Semana | Foco | Notas |
|---|---|---|---|
| L1  | 1  | Formação de grupos, segurança, leitura do guia | _ |
| L2  | 2  | Simulink, geração de sinais, D/A, primeiro comando ao motor | _ |
| L3  | 3  | A/D, leitura de sensores, calibração de `Kp` e `Ke` | _ |
| L4  | 4  | Sinal de excitação e recolha de dados de identificação | _ |
| L5  | 5 (qui) / 6 (seg) | Processamento de dados, ARMAX, escolha de ordens | _ |
| L6  | 6 (qui) / 7 (seg) | Integrador, espaço de estados, validação do modelo | _ |
| L7  | 9  | Revisão da identificação: polo do filtro, ordens, amostragem | _ |
| L8  | 10 | Projeto LQ, root-square locus em `R` | _ |
| L9  | 11 | Filtro de Kalman, LTR, simulação do LQG | _ |
| L10 | 12 | Diagrama LQG em tempo real, pré-filtro, primeiros testes na planta | _ |
| L11 | 13 | Afinação na planta: efeito de `R` e `Rv` | _ |
| L12 | 14 | Medidas finais em malha fechada. **Entrega do relatório** | _ |
| L13 | 15 | Avaliação final: validação coletiva e individual | _ |

## Texto de apoio (companion text)

- Resumo de state feedback design, referido na Secção 5 do guia. Leitura complementar, não obrigatória
- **EN:** `ApontamentosRLVEen.pdf` (neste repo)
- **PT:** disponível no Fénix

## ccpsGPT (tutor da cadeira)

- **Link:** https://tinyurl.com/ccpsGPT
- Conhece o programa, os módulos e o trabalho de laboratório. Gera exercícios com solução
- Usos úteis: pedir a mesma explicação de duas formas, exercícios-tipo por módulo, soluções com erro deliberado para encontrar, testar hipóteses (`R -> 0`?), erros comuns e o sintoma de cada um, problema de 30 min cronometrado
- **Limites:** pode estar errado com confiança. Aulas, vídeos e guia de laboratório prevalecem
- **Proibido** em MAP30, exame e avaliação final de laboratório (componentes vermelhas)

## Material suplementar (opcional, Módulo 5 / sessão L9)

- Modelos de perturbações aleatórias: `Random Disturbances - Models and Analysis.pdf` (Módulos 3.5 e 5.1)
- Otimalidade do filtro de Kalman, variância mínima: `dtKFopt.pdf` (Módulo 5.6)
- Dedução recursiva do filtro de Kalman discreto: `Derivation of the discrete-time Kalman filter.pdf` (Módulo 5.6)
- Survey de estimadores, Kalman a partículas: `Bayesian Filtering From Kalman Filters to Particle Filters, and Beyond.pdf` (fora do programa)

## Objetivos de aprendizagem

- **LO1** Estrutura e componentes de sistemas controlados por computador
- **LO2** Modelação em tempo discreto: equações às diferenças, funções de transferência, espaço de estados
- **LO3** Identificação de sistemas a partir de dados entrada-saída
- **LO4** Estabilidade, controlabilidade e observabilidade, contínuo vs. discreto
- **LO5** Controladores digitais: colocação de polos, LQR, LQG
- **LO6** Estimadores digitais: colocação de polos, filtros de Kalman
- **LO7** Model Predictive Control (MPC)
