directory_path = "D:/Stek/Path"

unless Dir.exist?(directory_path)
  puts "Path not found!"
  exit
end

file_names = Dir.entries(directory_path).select { |f| File.file?(File.join(directory_path, f)) }
file_names_without_extensions = file_names.map { |f| File.basename(f, ".*").downcase }

duplicates = file_names_without_extensions.group_by(&:itself).select { |_, files| files.size > 1 }

if duplicates.empty?
  puts "No duplicate files found."
else
  puts "Files with the same names found:"
  duplicates.each do |name, _|
    similar_files = file_names.select { |f| File.basename(f, ".*").casecmp?(name) }
    puts "- #{name}: #{similar_files.join(', ')}"
  end
end
