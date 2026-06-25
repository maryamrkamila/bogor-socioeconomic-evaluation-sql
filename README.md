# bogor-program-efficiency-evaluation-sql
SQL-based 4-quadrant matrix analysis to evaluate socio-economic program efficiency and resource allocation in Bogor City, utilizing Advanced SQL (CTEs & Window Functions).

# 📊 Spatial and Labor Market Policy Evaluation in Bogor City

**Author:** Maryam Rahma Kusuma Kamila | www.linkedin.com/in/maryamrkamila
**Date:** June 26, 2026  
**Tools Used:** SQL (MySQL)

## 📌 Project Overview
This project analyzes regional demographic and socio-economic data from BPS (Badan Pusat Statistik) to evaluate the efficiency of government assistance programs across 6 districts in Bogor City. By standardizing the ratio between the "Job Seeker Burden" and "Socio-Economic Program Performance" (RTLH reduction), this analysis maps the districts into a 4-quadrant evaluation matrix to identify policy bottlenecks and resource allocation inefficiencies.

## 🎯 Business Objective
The main goal is to optimize public resource efficiency. This project helps policymakers identify:
* Which districts require immediate priority intervention.
* Which districts are receiving excessive assistance relative to their actual needs (*over-allocated*).
* How to strategically reallocate budget to maximize socio-economic impact.

## 🛠️ Tools, Tech Stack & Methodology
* **Complex Data Modeling:** Aggregating and `JOIN`-ing 9 distinct raw datasets into a single analytical view.
* **Feature Engineering:** Standardizing raw data into fair, comparable metrics (calculating population density, facility ratios, and burden indexes per 1,000 population).
* **Window Functions:** Utilizing `AVG() OVER ()` to dynamically calculate city-wide baselines without hardcoding values.
* **Conditional Logic:** Using `CASE WHEN` to classify data into a 2x2 decision matrix.
* * **Window Functions:** Utilizing `AVG() OVER ()` to dynamically calculate city-wide baselines without hardcoding values. 
  *(Code snippet highlighted below)*:
  ```sql
  -- Dynamic Baseline Calculation
  AVG((jumlah_pencari_kerja / jumlah_penduduk) * 1000.0) OVER () AS avg_beban_kota,
  AVG((berkurangnya_jumlah_unit_rtlh / jumlah_penduduk) * 1000.0) OVER () AS avg_performa_kota

## 💡 The 4-Quadrant Classification & Key Findings
The analysis successfully categorized the districts based on their actual needs vs. program absorption rates:

| Quadrant | Status | District Identified | Key Insight | Actionable Move |
| :--- | :--- | :--- | :--- | :--- |
| **Q1** | 🔴 **Bottleneck** | Bogor Selatan, Tanah Sareal, Bogor Barat | **High burden, slow response.** Bogor Selatan peaks at a 3.26 burden index but shows the slowest program performance (0.88). | **Urgent Priority:** Needs immediate infrastructure intervention and aid distribution. |
| **Q2** | 🔵 **Highly Effective** | *- (None)* | High burden, high intervention. | On Target. | 
| **Q3** | 🟡 **Over-Allocated** | Bogor Timur | **Low burden, excessive aid.** Lowest unemployment burden (2.36) but massive aid volume (39.85, nearly 3x city average). | **Resource Inefficiency:** Reduce budget and redirect funds. |
| **Q4** | 🟢 **Stable Area** | Bogor Tengah, Bogor Utara | **Proportional balance.** Bogor Tengah maintains a healthy ecosystem due to its high public facility ratio (1.05). | **Controlled Capacity:** No heavy intervention needed. |

## 🚀 Actionable Recommendations
1. **Budget Reallocation:** The local government must strongly consider reducing the social program budget in **Bogor Timur** (Q3) and immediately reallocate those funds to **Bogor Selatan** (Q1), which is facing a structural employment emergency.
2. **Facility Equalization:** To prevent future unemployment explosions, priority must be given to building new public facilities in **Tanah Sareal** (which currently holds the lowest facility ratio at 0.48).

## 📂 How to Read This Repository
* `sql_scripts/bogor_socioeconomic_evaluation`: Contains the main SQL query using CTEs and Window Functions.
* `data/`: Contains the 9 raw CSV datasets used for this evaluation.

## 🌱 Future Scope (Next Steps)
If given more time and data, this analysis could be expanded by:
1. **Temporal Analysis:** Comparing this 2024 data with 2023 to see the Year-over-Year (YoY) trend of program effectiveness.
2. **Predictive Modeling:** Integrating this data with Python (Scikit-Learn) to predict which districts are most at risk of structural unemployment in the next 3 years.
