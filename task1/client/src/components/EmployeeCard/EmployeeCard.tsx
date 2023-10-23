import { ReactNode } from "react";
import "./EmployeeCard.scss"
import { EmployeeData } from "../../schema";
import emailIcon from "../../assets/email.svg"
import phoneIcon from "../../assets/phone.svg"
export type CardProps = {
	employeeData: EmployeeData,
	onClick: () => void
}
export default function EmployeeCard({ employeeData: { name, phone, email }, onClick }: CardProps): ReactNode {
	return (
		<li className="employeeCard" onClick={onClick}>
			<h2 className="employeeCard-name">{name}</h2>
			<span className="employeeCard-phone">
				<img src={phoneIcon} />
				<p>{phone}</p>
			</span>

			<span className="employeeCard-email">
				<img src={emailIcon} />
				<p>{email}</p>
			</span>
		</li >
	)
}
