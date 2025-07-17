# Data-Warehouse-Projekt

> 📄 Dieses Dokument ist in mehreren Sprachen verfügbar:

- 🇩🇪 [Deutsch](README.de.md)
- 🇬🇧 [English](README.md)

## Projektbeschreibung

Dieses Projekt implementiert ein vollständiges **SQL-basiertes Data Warehouse** mit einer modularen **Drei-Schichten-Architektur** (Bronze, Silber und Gold). Ziel ist es, rohe CRM- und ERP-Daten zu konsolidieren, zu bereinigen und in ein zuverlässiges, analysierbares Modell zu transformieren.

<img width="1160" height="773" alt="High Level Architecture" src="https://github.com/user-attachments/assets/4c308b1f-11f7-46c0-b024-066a728535ed" />


### 🟫 Bronze-Schicht – Rohdaten

Die Bronze-Schicht lädt Daten aus **zwei unterschiedlichen Quellen** im CSV-Format: `CRM` und `ERP`. Diese Dateien werden **unverändert** geladen, um die Rückverfolgbarkeit zu gewährleisten. Sollte ein Problem auftreten, können die ursprünglichen Daten jederzeit überprüft werden.

- **Datenquelle:** CSV-Dateien
- **Speicherung:** Tabellen in SQL Server
- **Ladestrategie:** `TRUNCATE + INSERT`
- **Transformationen:**  Keine (nur rohe Speicherung)

  <img width="1068" height="712" alt="Integration Model" src="https://github.com/user-attachments/assets/9d616ef0-574e-40fb-bf9f-ac21d9302ae4" />

---

### 🟦 Silber-Schicht – Bereinigte und standardisierte Daten

In der Silber-Schicht werden die Rohdaten **bereinigt, standardisiert und normalisiert**, während das Tabellen-Schema mit dem der Bronze-Schicht übereinstimmt (und somit auch mit den Quelldateien).

#### 🛠 Verwendete Techniken:
- **Datenbereinigung:** Entfernen von Duplikaten und ungültigen Werten, Auffüllen fehlender Daten
- **Datenstandardisierung:** Umwandlung von Codes (z. B. Geschlecht, Familienstand) in Klartext
- **Daten-Normalisierung:** Vereinheitlichung von Datums-, Preis- und Textformaten
- **Datenanreicherung:** Verbindung von CRM- und ERP-Daten anhand gemeinsamer Schlüssel

Diese Schicht stellt sicher, dass alle Daten **valide und geschäftstauglich** sind.

---

### 🟡 Gold-Schicht – Analytisches Modell

Die Gold-Schicht wandelt die standardisierten Daten in ein **Star-Schema** um, das sich ideal für Reporting, Business Intelligence oder Machine Learning eignet.

<img width="988" height="659" alt="Data Flow" src="https://github.com/user-attachments/assets/2228457c-0c72-407b-a8e9-27c88cb5355a" />

<img width="958" height="525" alt="Star Schema" src="https://github.com/user-attachments/assets/835298b2-40e0-4bad-be8d-0f22f4adf7c3" />


Es werden **drei Haupt-Entitäten** als Views modelliert:
- `gold.dim_customers` – Kunden-Dimension (mit CRM- und ERP-Daten)
- `gold.dim_products` – Produkt-Dimension (mit Kategorieinformationen)
- `gold.fact_sales` – Faktentabelle mit Verkaufsdaten

#### ✨ Highlights:
- **Datenintegration**: Verknüpfung und Anreicherung von CRM- und ERP-Daten
- **Aggregation**: Ableitung von Kennzahlen wie Gesamtumsatz
- **Datenmodell:** Star-Schema (Sternschema)

---

### 📊 Anwendungsbeispiele

Die Daten in der Gold-Schicht sind nun **organisiert, bereinigt und einsatzbereit** für verschiedene Zwecke wie:

-  **Power BI Dashboards** (z. B. Umsatz nach Kundensegmenten)
-  **Ad-hoc SQL-Abfragen** (z. B. Trendanalysen, Kundenverhalten)
-  **Machine Learning Modelle** (z. B. Churn Prediction, Produktempfehlungen)

---

### 🛠 Verwendete Technologien

- **SQL Server** – Datenbank-Engine
- **T-SQL** – Für ETL-Logik, Prozeduren und Views
- **CSV-Dateien** – Rohdatenquellen
- **Power BI / ML-Tools** – Für die Datenkonsumption

---

### Gelerntes & Konzepte

Im Verlauf des Projekts habe ich praktische Erfahrung mit den Grundlagen der **Datenengineering** gesammelt, darunter:

- ETL-Prozesse (Extract, Transform, Load)
- Datenbereinigung & -standardisierung
- Datenanreicherung & -normalisierung
- SQL-Views & Fensterfunktionen
- Modellierung mit Star-Schema
- Fakten- und Dimensionstabellen
- Layered Architecture (Bronze → Silber → Gold)
- Separation of Concerns in der Datenverarbeitung

---

### Abschließende Bemerkung

Dieses Projekt hat mir geholfen, die Kernprinzipien moderner Datenarchitektur mit SQL Server zu verstehen und anzuwenden.  
Dank der Schichtenstruktur ist das Data Warehouse sowohl **rückverfolgbar als auch skalierbar** – bereit für Reporting, Analytik oder datengestützte Entscheidungsfindung.

---
