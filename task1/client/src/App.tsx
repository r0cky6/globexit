import "./fonts.scss"
import "./App.scss"
import axios from "axios"
import { useEffect, useState } from "react"
import SearchBar from "./components/SearchBar/SearchBar.tsx"
import EmployeeCard from "./components/EmployeeCard/EmployeeCard.tsx"
import EmployeeDetailsModal from "./components/EmployeeDetailsModal/EmployeeDetailsModal.tsx"
import { EmployeeData } from "./schema.ts"

export const BASE_API_URL = import.meta.env.PROD && import.meta.env.VITE_API_URL || 'http://localhost:3000/'

function App() {
	const [employees, setEmployees] = useState<EmployeeData[]>([])
	const [modalOpen, setModalOpen] = useState<boolean>(false)
	const [employeeIndex, setEmployeeIndex] = useState<number>(0)

	const showEmployeeDetails = (index: number) => {
		setEmployeeIndex(index)
		setModalOpen(true)
		document.body.style.overflow = 'hidden'
	}

	useEffect(() => {
		axios.get(BASE_API_URL)
			.then((res: { data: EmployeeData[] }) => setEmployees(res.data))
			.catch(err => { throw new Error(err) })
	}, [])

	return (
		<>
			{
				modalOpen &&
				<EmployeeDetailsModal
					employeeData={employees[employeeIndex]}
					close={() => {
						setModalOpen(false)
						document.body.style.overflow = 'scroll'
					}}
				/>
			}
			<div className="app-container">
				<SearchBar setEmployees={setEmployees} />
				<ul className="employeeList">
					{
						employees?.map((el: EmployeeData, i: number) => (
							<EmployeeCard
								key={i}
								employeeData={el}
								onClick={() => showEmployeeDetails(i)}
							/>
						))
					}
				</ul>
			</div>
		</>
	)
}

export default App
