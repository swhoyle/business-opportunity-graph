# Business Opportunity Knowledge Graph
UCSD DSE 203 Project

## Goal
Help franchise planners identify promising regions for new business locations by combining geographic and business data into a knowledge graph.

## Solution
Build a knowledge graph in Neo4j that models Business, Region, Location entities within San Diego area.

Enrich the graph with LLM-derived insights to better categorize businesses and regions.

## Repository Instructions


- **Step 1:**
 
Create a local or neo4j instance.

- **Step 2:**

Connect to UCSD VPN to access the postgreSQL database.

- **Step 3:**

Create an .env file copying the format shared below and fill in your credentials and database details where it says <>.

- **Step 4:**

Install python packages in the requirements.txt file.

> pip install -r requirements.txt

- **Step 5:**

Install APOC, APOC-Extended and Graph Data Science (GDS) plugins for your neo4j instance. APOC is required for step 6, whereas APOC-Extended and GDS are required for parts of step 8. APOC-Extended is a separate library from APOC and needs to be installed manually following the instructions here: Installation - APOC Extended Documentation

- **Step 6:** 

Run _notebooks 01-04_ to create the knowledge graph.

- **Step 7:** 

Explore the neo4j graph using the cypher queries provided in the appendix.

- **Step 8:** 

Conduct additional explanation and analytics using the rest of the notebooks.

_05_neo4j_visualization_ contains sections to generate the degree distribution plots, the map visuals used for progress reports throughout the quarter and the heatmap of the graph mixing

_07_best_location contains_ sections to run the initial node regression analysis to predict avg_rating

_08_neo4j_graphrag_ contains a simple GraphRAG implementation to set it up and another section called Text2Cypher which has our actual GraphRAG implementation.
