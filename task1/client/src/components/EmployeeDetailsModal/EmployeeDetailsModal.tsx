import { ReactNode } from "react"
import { createPortal } from "react-dom"
import { EmployeeData } from "../../schema"
import "./EmployeeDetailsModal.scss"
import closeSvg from "../../assets/close.svg"

type EmployeeDetailsProps = {
	employeeData: EmployeeData,
	close: () => void
}

export default function EmployeeDetailsModal({ employeeData: { name, phone, email, position_name, department, hire_date }, close }: EmployeeDetailsProps): ReactNode {
	return createPortal(
		<div className="modal-container" onClick={close}>
			<div className="modal-content" onClick={(e) => e.stopPropagation()}>
				<div className="modal-header">
					<h2 className="employee-name">{name}</h2>
					<img className="modal-close" src={closeSvg} alt="close modal" onClick={close} />
				</div>
				<p className="employee-data-label">Телефон:</p>
				<p className="employee-data employee-phone">{phone}</p>
				<p className="employee-data-label">Почта:</p>
				<p className="employee-data employee-email">{email}</p>
				<p className="employee-data-label">Дата приема:</p>
				<p className="employee-data employee-hireDate">{hire_date}</p>
				<p className="employee-data-label">Должность:</p>
				<p className="employee-data employee-positionName">{position_name}</p>
				<p className="employee-data-label">Подразделение:</p>
				<p className="employee-data employee-department">{department}</p>
				<div className="modal-footer">
					<p className="employee-data-label label-additionalInfo">Дополнительная информация:</p>
					<p className="employee-data employee-additionalInfo">
						Разработчики используют текст в качестве заполнителя макта страницы.
						Разработчики используют текст в качестве заполнителя макта страницы.
					</p>
				</div>
			</div>
		</div>
		, document.body
	)
}
