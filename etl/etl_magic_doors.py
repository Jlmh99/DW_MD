import pandas as pd

usuarios = pd.read_csv("data/usuarios.csv")
aulas = pd.read_csv("data/aulas.csv")
materias = pd.read_csv("data/materias.csv")
grupos = pd.read_csv("data/grupos.csv")
sesiones = pd.read_csv("data/sesiones_aula.csv")
accesos = pd.read_csv("data/registro_accesos.csv")

usuarios = usuarios.drop_duplicates()
usuarios["email"] = usuarios["email"].str.lower()

aulas = aulas.drop_duplicates()
materias = materias.drop_duplicates()
grupos = grupos.drop_duplicates()

accesos["timestamp"] = pd.to_datetime(accesos["timestamp"])

print("ETL ejecutado correctamente")
