---
tipo: proyecto
nombre: "{{VALUE}}"
cliente: "<% tp.system.prompt('Cliente') %>"
tags: [proyecto]
---

# {{VALUE}}

**Cliente:** <% tp.frontmatter.cliente %>

## PIs

```dataview
TABLE without id
	file.link as "PI",
	status as "Estado",
	fecha_inicio as "Inicio",
	fecha_fin as "Fin"
FROM "proyectos/{{VALUE}}"
WHERE tipo = "pi"
SORT pi DESC
```

## Contactos relacionados

```dataview
TABLE
	siglum as "Siglum",
	rol as "Rol"
FROM "contactos"
WHERE proyecto = "{{VALUE}}"
SORT nombre ASC
```

## Backlog

- [ ]

## Notas
