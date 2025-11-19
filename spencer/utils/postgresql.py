import pandas as pd
import psycopg2
import os
import decimal

from dotenv import load_dotenv

load_dotenv()

class PostgreSQL:
    def __init__(self, host, port, dbname, user, password):
        self.conn = psycopg2.connect(
            host=host,
            port=port,
            dbname=dbname,
            user=user,
            password=password
        )

    def _convert(self, value):
        """Convert database values to Python-native types."""
        if isinstance(value, decimal.Decimal):
            return float(value)
        return value

    def query(self, query):
        with self.conn.cursor() as cursor:
            cursor.execute(query)
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()

        rows = [[self._convert(v) for v in row] for row in rows]
        return pd.DataFrame(rows, columns=columns)

db = PostgreSQL(
    host="awesome-hw.sdsc.edu",
    port=5432,
    dbname="nourish",
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD")
)