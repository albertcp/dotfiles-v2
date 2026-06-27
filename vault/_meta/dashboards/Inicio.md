---
tags: [dashboard, home]
---
****************
# 🏠 Inicio

**Acceso rápido:** `= "[[" + dateformat(date(today), "yyyy-MM-dd") + "|📅 Hoy]]"` · [[_meta/dashboards/Contactos.md|📇 Contactos]] · [[proyectos|📂 Proyectos]]

---

> [!example]- 📂 Proyectos
> 
> ```dataview
> TABLE without id
> 	file.link as "Proyecto",
> 	cliente as "Cliente"
> FROM "proyectos"
> WHERE tipo = "proyecto"
> SORT file.name ASC
> ```

> [!warning]- 📌 PIs Activos
> 
> ```dataview
> TABLE without id
> 	file.link as "PI",
> 	proyecto as "Proyecto",
> 	fecha_inicio as "Inicio",
> 	fecha_fin as "Fin"
> FROM "proyectos"
> WHERE tipo = "pi" AND status = "activo"
> SORT fecha_fin ASC
> ```

> [!success]- 🏃 Sprint Actual
> 
> ```dataview
> TASK FROM "proyectos"
> WHERE !completed AND contains(file.folder, "Sprint") AND status = "activo"
> GROUP BY file.link
> SORT file.folder ASC
> ```

> [!note]- 📋 Backlog
> 
> ```dataview
> TASK FROM "proyectos"
> WHERE !completed AND (!contains(file.folder, "Sprint") OR status != "activo")
> GROUP BY file.link
> SORT file.folder ASC
> ```

> [!quote]- 👥 Últimos Contactos
> 
> ```dataview
> TABLE without id
> 	file.link as "Nombre",
> 	siglum as "Siglum",
> 	rol as "Rol",
> 	proyecto as "Proyecto"
> FROM "contactos"
> WHERE tipo = "contacto"
> SORT file.ctime DESC
> LIMIT 5
> ```
