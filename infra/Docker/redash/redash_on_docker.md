```mermaid
graph LR

    subgraph WSL
        subgraph Docker
            subgraph Redashコンテナ
                A[Redash]
            end
            subgraph Postgresqlコンテナ
                B[Postgres]
            end
        end
        A[Redash]---B[Postgres]
    end
```