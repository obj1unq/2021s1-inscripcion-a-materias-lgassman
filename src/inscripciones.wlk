/** First Wollok example */
class Materia {
	
	const inscriptos = []
	const cupo = 30
	
	const property creditos = 5
	const property anio = 1
	
	const estrategiaDeRequisitos = ningunRequisito
	
	method cumpleRequisitos(_estudiante) {
		return estrategiaDeRequisitos.cumpleRequisitos(_estudiante, self)
	}
	
	method inscribir (estudiante) {
		inscriptos.add(estudiante)
	}
	
	method desinscribir(estudiante) {
		inscriptos.remove(estudiante)
	}
	
	method confirmados() {
		return inscriptos.subList(0, cupo - 1)
	}
	
	method espera() {
		return inscriptos.subList(cupo)
	}
		
	method inscripto(estudiante) {
		return inscriptos.contains(estudiante)
	}	
	
}

object ningunRequisito {
	method cumpleRequisitos(_estudiante, materia) {
		return true
	}
}

class RequisitosPorCreditos {
	
	const creditosNecesarios
	
	method cumpleRequisitos(_estudiante, materia) {
		return _estudiante.creditos() >= creditosNecesarios	
	}
}

object requisitoPorAnio  {
	
	method cumpleRequisitos(_estudiante, materia) {
		return _estudiante.aproboAnioAnterior(materia)	
	}
	
}

class RequisitosPorCorrelativas {
	const requisitos = #{}

	method cumpleRequisitos(_estudiante, materia) {
		return requisitos.all({requisito => _estudiante.aprobada(requisito)})
	}
	
}


class Estudiante {
	const cursadasAprobadas = #{}	
	const carreras = #{}
	
	method validarAprobacion(_materia) {
		if(self.aprobada(_materia)) {
			self.error("no se puede aprobar una materia ya aprobadas")
		}
	}
	
	method aprobar(_materia, _nota) {
		self.validarAprobacion(_materia)
		cursadasAprobadas.add(new CursadaAprobada(materia=_materia, nota=_nota))
	}
	
	method aprobada(_materia) {
		return cursadasAprobadas.any({cursada => cursada.materia() == _materia} )
	}
	
	method cantidadMateriasAprobadas() {
		return cursadasAprobadas.size()
	}
	
	method promedio() {
		//el max 1 es para que un alumno sin notas tenga 0 de promedio
		return self.sumatoriaNotas() / self.cantidadMateriasAprobadas().max(1) 
	}
	
	
	method sumatoriaNotas() {
		return cursadasAprobadas.sum({ cursada => cursada.nota()})
	}
	
	method todasLasMaterias() {
		//return carreras.map({carrera => carrera.materias()}).flatten().asSet()
		return carreras.flatMap({carrera => carrera.materias()})
	}
	
	method validarInscripcion(_materia) {
		if (not self.puedeInscribirse(_materia)) {
			self.error("No se puede inscribir a la materia")
		}
	}
	
	method inscribir(_materia) {
		self.validarInscripcion(_materia)
		_materia.inscribir(self)
	}
	
	method puedeInscribirse(_materia) {
		return not self.aprobada(_materia) &&
				not self.inscripto(_materia) &&
				_materia.cumpleRequisitos(self) &&
				self.cursaLaCarrera(_materia)
	}
	
	method inscripto(_materia) {
		return _materia.inscripto(self)
	}
	
	method cursaLaCarrera(_materia) {
		return carreras.any({carrera => carrera.contiene(_materia)})
	}
	
	method validarDesinscribir(materia) {
		if( not self.inscripto(materia)) {
			self.error("no se puede desinscribir")
		}
	}
	method desinscribir(materia) {
		self.validarDesinscribir(materia)
		materia.desinscribir(self)
	}
	
	method creditos() {
		return cursadasAprobadas.sum({cursada => cursada.creditos()})
	}
	
	method aproboAnioAnterior(materia) {
		return self.carrerasDe(materia).any({carrera => carrera.aproboAnio(self, materia.anio() - 1) })
	}
	
	method carrerasDe(_materia) {
		return carreras.filter({carrera => carrera.contiene(_materia)})
	}
	
	
}

class Carrera {
	const property materias = #{}
	
	method contiene(_materia) {
		return materias.contains(_materia)
	}
	
	method aproboAnio(_estudiante, anio) {
		return self.materiasDelAnio(anio).all({materia => _estudiante.aprobada(materia)})
	}
	
	method materiasDelAnio(anio) {
		return materias.filter({materia => materia.anio() == anio })
	}
	
}

class CursadaAprobada {
	const property materia
	const property nota
	
	method creditos() {
		return materia.creditos() 
	}
}

