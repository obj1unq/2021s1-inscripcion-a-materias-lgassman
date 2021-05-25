/** First Wollok example */
class Materia {
	
}

class Carrera {
	const property materias
}

class Estudiante {
	const cursadasAprobadas = #{}
	const carreras = #{}
	
	method aprobar(materia, nota) {
		cursadasAprobadas.add(new Cursada(materia=materia, nota=nota))
	}
	
	method aprobada(materia) {
		return cursadasAprobadas.any({cursada => cursada.materia() == materia})
	}
	
	method promedio() {
		return cursadasAprobadas.sum({cursada => cursada.nota()}) / self.cantidadMateriasAprobadas()
	}
	
	method cantidadMateriasAprobadas() {
		return cursadasAprobadas.size()
	}
	
	method todasLasMaterias() {
		return carreras.flatMap({carrera => carrera.materias()})
		//return carreras.map({carrera => carrera.materias()}).flatten().asSet()
	}
}

class Cursada {
	const property nota
	const property materia
}
