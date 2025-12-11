# Business Opportunity Knowledge Graph
UCSD DSE 203 Project

## Goal
Help franchise planners identify promising regions for new business locations by combining geographic and business data into a knowledge graph.

## Solution
Build a knowledge graph in Neo4j that models Business, Region, Location entities within San Diego area.

Enrich the graph with LLM-derived insights to better categorize businesses and regions.

## Technology Stack
- PostgreSQL – Source of relational data
- Python – Data extraction, cleaning, transformation
- Pandas – Data manipulation
- Neo4j – Knowledge graph database
- LLM – Optional semantic enrichment

## Graph Model

### Entities (Nodes)

- `Business`
- `Store`
- `State`
- `County`
- `City`
- `Community`
- `Zipcode`
- `Block Group`

### Relationships (Edges)
- `County` -> contained in -> `State`
- `City` -> contained in -> `County`
- `Community` -> contained in -> `City`
