---
tags: [dashboard]
---

# 📇 Contactos

## Todos los contactos

```dataview
TABLE without id
	file.link as "Nombre",
	siglum as "Siglum",
	empresa as "Empresa",
	rol as "Rol",
	proyecto as "Proyecto"
FROM "contactos"
WHERE tipo = "contacto"
SORT nombre ASC
```

---

## Por proyecto

```dataview
TABLE without id
	file.link as "Nombre",
	siglum as "Siglum",
	empresa as "Empresa",
	rol as "Rol"
FROM "contactos"
WHERE tipo = "contacto"
SORT proyecto ASC, nombre ASC
GROUP BY proyecto
```
