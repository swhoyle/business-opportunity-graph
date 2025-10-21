# Graph Model

# Entities (Nodes)

- `Business`
- `Store`
- `State`
- `County`
- `City`
- `Community`
- `Zipcode`
- `Block Group`

# Relationships (Edges)
- `County` -> contained in -> `State`
- `City` -> contained in -> `County`
- `Community` -> contained in -> `City`