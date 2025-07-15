# sql-data-warehause-project
Building a modern data warehouse with SQL Server, including ETL processes, data modeling and analytics.

🏗️ Data Engineering Warehouse Project

**🇩🇪 Deutsche Beschreibung**

Dieses Projekt ist eine praktische Umsetzung eines modernen Data Warehouses, das ich im Rahmen meines Lernwegs im Bereich Data Engineering entwickelt habe. Ziel ist es, den vollständigen Datenfluss von der Quelle bis zur nutzbaren Information zu zeigen – mit Fokus auf gute Strukturierung und Datenqualität.

📚 Projektziel
Aufbau eines dreischichtigen Data Warehouses, basierend auf dem Prinzip der Trennung von Verantwortlichkeiten („Separation of Concerns“), mit Fokus auf Datenbereinigung, Standardisierung und geschäftsrelevante Transformationen.

🛠️ Technische Übersicht
Das System verarbeitet Daten aus zwei unterschiedlichen Datenbanken in drei klar getrennten Schichten:

🔹 Schicht 1 – Rohdaten (Staging) (Bronze)
Direkte Übernahme der Daten in ursprünglicher Form.

Keine Transformation – reine Speicherung.

Dient als historische Quelle mit vollständiger Nachvollziehbarkeit.

🔹 Schicht 2 – Bereinigte & Angereicherte Daten (Silver)
Bereinigung, Standardisierung und Anreicherung der Daten.

Vereinheitlichung von Spaltennamen, Formaten, Datentypen und Logik.

Schafft zuverlässige, strukturierte Ausgangsdaten.

🔹 Schicht 3 – Business Layer (Gold)
Transformationen mit Fokus auf die geschäftliche Nutzung.

Erstellung von Modellen und Aggregationen für Analysen.

Daten sind direkt nutzbar für Berichte, BI-Tools und Entscheidungen.

🎯 Lernziele
Verständnis für den Aufbau eines Data Warehouses mit Schichten.

Anwendung des Prinzips der Trennung von Verantwortlichkeiten.

Praxis in Datenbereinigung, Normalisierung und Anreicherung.

Bereitstellung geschäftsrelevanter, analysierbarer Daten.

🚧 Project Status / Projektstatus
🟡 In development – This repository is being actively developed as I build and expand the pipeline step by step.
🟡 In Entwicklung – Dieses Repository wird laufend erweitert, während ich das Pipeline-System schrittweise aufbaue.

**🇬🇧 English Description**

This project is a practical implementation of a modern data warehouse, built as part of my learning journey in Data Engineering and to showcase a full pipeline in my portfolio. The goal is to demonstrate good practices in data ingestion, cleaning, transformation, and modeling using a layered architecture with clear separation of concerns.

📚 Project Goal
To build a three-layer Data Warehouse, based on the principle of Separation of Concerns, with a focus on data quality, standardization, and business-ready transformations.

🛠️ Technical Overview
The system ingests data from two different database sources and processes them through three structured layers:

🔹 Layer 1 – Raw Layer (Staging) (Bronze)
Direct ingestion of data as-is from the original sources.

No transformation is applied.

Provides historical backup and full traceability.

🔹 Layer 2 – Cleaned & Enriched Layer (Silver)
Data cleaning, standardization, and enrichment.

Unifies column names, formats, types, and resolves inconsistencies.

Prepares data for semantic consistency and reliability.

🔹 Layer 3 – Business Layer (Gold)
Business-focused transformations.

Produces analysis-ready data models and aggregates.

Designed for reporting, BI tools, and decision-making.

🎯 Learning Goals
Understand the layered architecture of a Data Warehouse.

Practice the Separation of Concerns principle in data workflows.

Apply cleaning, normalization, and enrichment techniques.

Deliver data in a format usable by business users and tools.
