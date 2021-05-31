/** First Wollok example */
class Materia {
	const requisitos = #{}
	
	const inscriptos = []
	const cupo = 30
	
	method cumpleRequisitos(_estudiante) {
		return requisitos.all({requisito => _estudiante.aprobada(requisito)})
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
	
	
}

class Carrera {
	const property materias = #{}
	
	method contiene(_materia) {
		return materias.contains(_materia)
	}
	
}

class CursadaAprobada {
	const property materia
	const property nota
}

