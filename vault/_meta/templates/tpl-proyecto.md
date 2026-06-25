---
tipo: proyecto
nombre: "<% tp.system.prompt("Nombre del proyecto") %>"
cliente: "<% tp.system.prompt("Cliente") %>"
tags: [proyecto]
---

# <% tp.frontmatter.nombre %>

**Cliente:** <% tp.frontmatter.cliente %>

## PIs

```dataview
TABLE without id
	file.link as "PI",
	status as "Estado",
	fecha_inicio as "Inicio",
	fecha_fin as "Fin"
FROM "proyectos/<% tp.frontmatter.nombre %>"
WHERE tipo = "pi"
SORT pi DESC
```

## Contactos relacionados

```dataview
TABLE
	siglum as "Siglum",
	rol as "Rol"
FROM "contactos"
WHERE proyecto = "<% tp.frontmatter.nombre %>"
SORT nombre ASC
```

## Backlog

- [ ]

## Notas

