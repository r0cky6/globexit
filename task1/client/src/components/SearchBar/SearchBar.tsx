import { ReactNode, SetStateAction } from "react";
import { EmployeeData } from "../../schema";
import './SearchBar.scss'
import searchIcon from "../../assets/search.svg"
import axios from "axios";
import { BASE_API_URL } from '../../App'
type SearchBarProps = {
	setEmployees: React.Dispatch<SetStateAction<EmployeeData[]>>
}
export default function SearchBar({ setEmployees }: SearchBarProps): ReactNode {
	const fetchEmployees = (query: string | null) => {
		const url = BASE_API_URL + (query && `?term=${query}` || "")
		axios.get(url)
			.then((res: { data: EmployeeData[] }) => setEmployees(res.data))
			.catch(err => { throw new Error(err) })
	}
	return (
		<form className="searchBar-form">
			<div className="searchBar-wrapper">
				<input
					name="query"
					type="text"
					onChange={(e) => fetchEmployees(e.target.value)} />
				<button
					type="submit"
					onClick={(e) => {
						e.preventDefault()
						const query = new FormData(e.currentTarget.form || undefined).get("query")?.toString()
						fetchEmployees(query || null)
					}}
				>
					<img src={searchIcon} alt="search" />
				</button>
			</div>
		</form >
	)
}
